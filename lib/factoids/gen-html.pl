#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use lib './lib';

use Path::Tiny qw/ path /;
use File::Update qw/ write_on_change write_on_change_no_utf8 /;
use JSON::MaybeXS             ();
use XML::LibXML               ();
use XML::LibXML::XPathContext ();
use XML::Grammar::Fortune 0.0800;
use Template                               ();
use Shlomif::Homepage::FactoidsPages::Page ();
use Carp::Always;
use List::Util qw/ uniqstr /;

my $p = XML::LibXML->new;

my $fortune_proc   = XML::Grammar::Fortune->new;
my $facts_xml_path = './lib/factoids/shlomif-factoids-lists.xml';
my $dom            = $p->parse_file($facts_xml_path);

my %deps;
foreach my $list_node ( $dom->findnodes("//list/\@xml:id") )
{
    foreach my $lang (qw(en-US he-IL))
    {
        my $list_id = $list_node->value;

        my $basename  = "$list_id--$lang";
        my $indiv_dom = $fortune_proc->perform_xslt_translation(
            {
                output_format => 'html',
                source        => { dom => $dom },
                output        => "dom",
                xslt_params   => {
                    'filter-facts-list.id' => "'$list_id'",
                    'filter.lang'          => "'$lang'",
                }
            }
        );

        my $xpc = XML::LibXML::XPathContext->new($indiv_dom);
        $xpc->registerNs( 'xhtml', "http://www.w3.org/1999/xhtml" );

        if ( $lang eq 'he-IL' )
        {
            foreach my $node (
                $xpc->findnodes(
"//xhtml:table/xhtml:tbody/xhtml:tr[\@class='author']/xhtml:td[\@class='field']/xhtml:b[text() = 'Author']"
                )
                )
            {
                $node->replaceChild( XML::LibXML::Text->new("מאת:"),
                    $node->firstChild );
            }
        }

        my $node =
            $xpc->findnodes("//xhtml:div[\@class='main_facts_list']")->[0];

        my $reduced_xhtml =
            "lib/factoids/indiv-lists-xhtmls/$basename.xhtml.reduced";
        write_on_change( scalar( path($reduced_xhtml) ),
            \( $node->toString =~ s/\s+xmlns:xsi="[^"]+"//gr ) );
        push @{ $deps{$list_id} }, $reduced_xhtml;
    }
}

my @chuck_pages = (
    {
        abstract => <<'EOF',
<p>
These are additions to the
<a href="https://en.wikipedia.org/wiki/Chuck_Norris_facts">Chuck
Norris facts</a> trend by my Internet friends and by me. Most of them are kinda
geeky (or even computer geeky), but some are more generic.
</p>

<p>
Reading from the wikipedia page:
</p>

<blockquote>
<p>
Chuck Norris “facts” are satirical factoids about martial artist and actor
<a href="http://en.wikipedia.org/wiki/Chuck_Norris">Chuck Norris</a> that
have become an Internet phenomenon and as a result have
become widespread in popular culture. The “facts” are normally absurd
hyperbolic claims about Norris’ toughness, attitude, virility, sophistication,
and masculinity.
</p>
</blockquote>
EOF
        id_base         => "chuck_facts",
        img_alt         => "Photo of Chuck Norris from the English Wikipedia",
        img_attribution =>
            'http://en.wikipedia.org/wiki/File:Norrishuckabee.JPG',
        img_class      => "facts_logo chuck_norris",
        img_src        => "humour/bits/facts/images/chuck-norris-1-150w.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2010",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://www.chucknorrisfacts.com/">Main Chuck Norris facts site</a> -
with thousands of factoids.
</p>
</li>

<li>
<p>
<a href="http://www.neobytesolutions.com/chuck-norris-programmer-facts-part-1/">Chuck Norris Programmer Facts - part 1</a>
</p>
</li>

<li>
<p>
<a href="http://www.direct2tv.com/chuck-norris-turns-73.html">Chuck Norris
Turns 73</a> (again).
</p>
</li>


<li>
<p>
<a
href="[% base_path %]philosophy/philosophy/putting-all-cards-on-the-table-2013/">“Putting
all the Cards on the Table (2013)”</a> (also by me) - mentions what is the
second major battle that Chuck Norris lost.
</p>

<ul>

<li>
<p>
<a
href="[% base_path %]philosophy/philosophy/putting-cards-on-the-table-2019-2020/">“Putting
Cards on the Table (2019-2020)”</a> (also by me) - additional update on
Chuck Norris and the facts.
</p>
</li>

</ul>

</li>

</ul>
EOF
        meta_desc =>
"Additional Chuck Norris Factoids by Shlomi Fish and Friends. No one is as tough as Norris.",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS foss_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ul>

<li>
<p>
<a href="[% base_path %]humour/Muppets-Show-TNI/Summer-Glau-and-Chuck-Norris.html">Chuck Norris
and Summer Glau on the Muppet Show as two ruthless Grammar Nazis</a>
</p>
</li>

</ul>
EOF
        short_id   => 'chuck',
        tabs_title => "Chuck Norris Facts",
        title      => "Chuck Norris Facts",
        url_base   => "Chuck-Norris",
    },
);

my @soviet_pages = (
    {
        abstract => <<'EOF',
<p>
Additions to the
<a href="http://knowyourmeme.com/memes/in-soviet-russia">In
Soviet Russia…</a> (or “Soviet reversal”) meme by my friends and me.
</p>
EOF
        id_base         => "in_soviet_russia_facts",
        img_alt         => "Soviet Russia",
        img_attribution =>
'http://commons.wikimedia.org/wiki/File:Flag_of_the_Soviet_Union.svg',
        img_class => "facts_logo in_soviet_russia",
        img_src   => "humour/bits/facts/images/soviet-union-modified.min.svg",
        license_method => "by_sa_british_blurb",
        license_year   => "2013",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="https://en.wikipedia.org/wiki/Russian_reversal">Russian
reversal (“In Soviet Russia”) on the Wikipedia</a>
</p>
</li>

</ul>
EOF
        meta_desc      => "In Soviet Russia, jokes laugh at you.",
        nav_blocks_tt2 => <<'EOF',
EOF
        see_also => <<'EOF',
<ul>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Chuck-Norris/">Chuck Norris Facts</a> -
another popular Internet meme.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/NSA/">NSA facts</a> - more
anti-authoritarianism stuff.
</p>
</li>

</ul>
EOF
        short_id   => 'in_soviet_russia',
        tabs_title => "“In Soviet Russia” Aphorisms",
        title      => "“In Soviet Russia” Additions",
        url_base   => "In-Soviet-Russia",
    },
);

my @main_pages = (
    {
        abstract => <<'EOF',
<p>
Facts about
<a href="http://buffy.wikia.com/wiki/Buffy_Summers">Buffy Summers</a>,
the main protagonist of the television show
<a href="http://en.wikipedia.org/wiki/Buffy_the_Vampire_Slayer_%28TV_series%29"><i>Buffy
the Vampire Slayer</i></a>, as created by
<a href="http://en.wikipedia.org/wiki/Joss_Whedon">Joss
Whedon</a> and portrayed by
<a href="http://en.wikipedia.org/wiki/Sarah_Michelle_Gellar">Sarah Michelle Gellar</a>.
</p>
EOF
        id_base => 'buffy_facts',
        img_alt =>
"Photo of Buffy Summers from the show’s DVD via the English Wikipedia",
        img_attribution => 'http://en.wikipedia.org/wiki/File:S514_Buffy.png',
        img_class       => "facts_logo buffy",
        img_src => "humour/bits/facts/images/SMG-as-buffy-from-wikipedia.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2013",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://buffy.wikia.com/">Buffy the Vampire Slayer and Angel Wiki</a>
- a wiki about the show and the Buffy universe.
</p>
</li>

<li>
<p>
<a href="http://buffyfanfiction.wikia.com/">Buffy Fanfiction Fandom.com Wiki</a>
( <a href="http://buffyfanfiction.wikia.com/wiki/Buffy_facts">Buffy
facts page</a> there).
</p>
</li>

<li>
<p>
<a href="https://twitter.com/search?q=%23buffyfacts&amp;src=typd">#buffyfacts
tag on Twitter</a>
</p>
</li>

</ul>
EOF
        meta_desc => "Facts about Buffy Summers from Buffy the Vampire Slayer",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS buffy_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ul>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Xena/">Xena Facts</a> - facts about Xena
the Warrior Princess (another tough chick).
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Clarissa/">Clarissa Darling Facts</a> - about
another pre-Buffy heroine.
</p>
</li>

<li>
<p>
<a href="http://unarmed.shlomifish.org/2396.html">“About
Female Action Heroes”</a> - my post as response to <a href="http://actionflickchick.com/superaction/wired-interviews-the-action-flick-chick-geek-cultures-26-most-awesome-female-ass-kickers/">a post about an interview with
Action Flick Chick about Geek Culture’s 26 Most Awesome
Female Ass-Kickers</a>.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/Selina-Mandrake/"><i>Selina Mandrake
- The Slayer</i></a> - my own Buffy parody/anti-thesis/modernisation.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/Buffy/A-Few-Good-Slayers/"><i>Buffy: A Few
Good Slayers</i></a> - a work-in-progress screenplay that is a more traditional
Buffy fanfic. Set in a fork of the Buffy universe, and takes place in 2014/2015
Sunnydale, where the Scooby Gang are adults, married men and women, parents,
and teachers/mentors.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/Summerschool-at-the-NSA/"><i>Summerschool
at the NSA</i></a> - another screenplay with a strong Buffy/Sarah Michelle
Gellar theme.
</p>
</li>

</ul>
EOF
        short_id   => 'buffy',
        tabs_title => 'Buffy Facts',
        title      => 'Buffy Facts',
        url_base   => "Buffy",
    },
    {
        abstract => <<'EOF',
<p>
Facts about Clarissa Darling, the protagonist of the show
<a href="http://en.wikipedia.org/wiki/Clarissa_Explains_It_All"><i>Clarissa
Explains It All</i></a>, as created by
<a href="http://en.wikipedia.org/wiki/Mitchell_Kriegman">Mitchell Kriegman</a>
and played by
<a href="http://en.wikipedia.org/wiki/Melissa_Joan_Hart">Melissa Joan Hart</a>.
</p>
EOF
        id_base         => "clarissa_facts",
        img_alt         => "Photo of the First DVD of CEIA from the Wikipedia",
        img_attribution =>
'http://en.wikipedia.org/wiki/File:Clarissa_Explains_it_All_Season_1.jpg',
        img_class      => "facts_logo clarissa",
        img_src        => "humour/bits/facts/images/clarissa-150w.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2013",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://en.wikipedia.org/wiki/Clarissa_Explains_It_All">Clarissa Explains It All on the English Wikipedia</a>
</p>
</li>

<li>
<p>
<a href="http://www.imdb.com/title/tt0101065/">Clarissa Explains It All - IMDB Entry</a>
</p>
</li>

</ul>
EOF
        meta_desc =>
"Clarissa Darling facts (from Clarissa Explains it All) - what you would not imagine about this smart cookie.",
        nav_blocks_tt2 => <<'EOF',
EOF
        see_also => <<'EOF',
<ul>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Xena/">Xena Facts</a> -
about another pre-Buffy heroine.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Buffy/">Buffy Facts</a> - facts about Buffy
herself.
</p>
</li>

</ul>
EOF
        short_id   => 'clarissa',
        tabs_title => "Clarissa Darling Facts",
        title      => "Clarissa Darling Facts (from Clarissa Explains it All)",
        url_base   => "Clarissa",
    },
    {
        abstract => <<'EOF',
[% PROCESS emma_watson_intro_text %]
EOF
        id_base         => "emma_watson_facts",
        img_alt         => "Photo of Emma Watson from the Wikipedia",
        img_attribution =>
            'http://en.wikipedia.org/wiki/File:Emma_Watson_2013.jpg',
        img_class      => "facts_logo emma_watson",
        img_src        => "humour/bits/facts/images/emwatson-small.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2014",
        links_tt2      => <<'EOF',
<ul>

[% PROCESS emma_watson_common_links  %]

</ul>
EOF
        meta_desc      => "Factoids about Emma Watson, the British actress",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS harry_potter_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ul>

[% PROCESS emma_watson__see_also  %]

</ul>
EOF
        short_id   => 'emma_watson',
        tabs_title => "Emma Watson Facts",
        title      => "Emma Watson Facts",
        url_base   => "Emma-Watson",
    },
    {
        abstract => <<'EOF',
<p>
<a href="http://www-cs-staff.stanford.edu/~uno/">Don Knuth</a> (born
1938) is a professor
Emeritus of Computer Science at Stanford University, and is the creator
of <a href="http://en.wikipedia.org/wiki/TeX">TeX</a>, inventor of several
important algorithms and author of
<a href="http://en.wikipedia.org/wiki/The_Art_of_Computer_Programming"><i>The Art of Computer Programming</i></a>.
</p>

<p>
These facts explain why he isn’t God, but pretty close.
</p>
EOF
        id_base => "knuth_is_not_god_facts",
        img_alt => "Photo of Prof. Don Knuth from Flickr via the Wikipedia",
        img_attribution =>
            'http://en.wikipedia.org/wiki/File:KnuthAtOpenContentAlliance.jpg',
        img_class      => "facts_logo knuth",
        img_src        => "humour/bits/facts/images/knuth-small.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2002",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://www-cs-faculty.stanford.edu/~uno/">Don Knuth’s
Homepage at Stanford University</a> - by the man himself. Contains a lot of weird and zany stuff.
</p>
</li>

<li>
<p>
<a href="http://www.informit.com/articles/article.aspx?p=1193856">Interview
with Knuth</a>
</p>
</li>

</ul>
EOF
        meta_desc =>
"Why Prof. Don Knuth (= the famous computer scientist) is not God, but is pretty close.",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS foss_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ul>
<li>
<p>
<a href="[% base_path %]humour/human-hacking/"><i>The Human Hacking Field Guide</i></a> -
a story about open source developers (or "hackers").
</p>
</li>
</ul>
EOF
        short_id   => 'knuth',
        tabs_title => "Why Knuth is Not God",
        title      => "Knuth Facts",
        url_base   => "Knuth",
    },
    {
        abstract => <<'EOF',
<p>
<a href="http://en.wikipedia.org/wiki/Larry_Wall">Larry Wall</a> (born
1954) is the
creator of the Perl programming language, and the inventor of the
<a href="http://en.wikipedia.org/wiki/Patch_%28Unix%29">patch program</a>,
and of the <a href="https://en.wikipedia.org/wiki/Rn_(newsreader)">rn
newsreader</a>. These facts illustrate his “hacky” (= rule bending) awesomeness.
</p>
EOF
        id_base         => "larry_wall_facts",
        img_alt         => "Larry Wall",
        img_attribution =>
            'http://en.wikipedia.org/wiki/File:Larry_Wall_YAPC_2007.jpg',
        img_src        => "humour/bits/facts/images/lwall-150w.webp",
        img_class      => "facts_logo larry_wall",
        license_method => "by_sa_british_blurb",
        license_year   => "2007",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://en.wikiquote.org/wiki/Larry_Wall">Larry Wall Quotes on Wikiquote</a>
</p>
</li>

</ul>
EOF
        meta_desc =>
"Factoids about Larry Wall, the creator of the Perl programming language, and the UNIX patch utility.",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS foss_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
        short_id   => 'lwall',
        tabs_title => "Larry Wall Facts",
        title      => "Larry Wall Facts",
        url_base   => "Larry-Wall",
    },
    {
        abstract => <<'EOF',
<p>
The
<a href="http://en.wikipedia.org/wiki/National_Security_Agency">NSA</a>
is the United States’ National Security Agency, a cryptologic intelligence
agency. These facts show why the NSA is a paper tiger, and a money sink, and
why it should not be feared.
</p>

EOF
        id_base         => "nsa_facts",
        img_alt         => "NSA Logo",
        img_attribution =>
'http://commons.wikimedia.org/wiki/File:National_Security_Agency.svg',
        img_class      => "facts_logo nsa",
        img_src        => "humour/bits/facts/images/nsa-150w.png",
        license_method => "by_british_blurb",
        license_year   => "2013",
        links_tt2      => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
        meta_desc =>
"Factoids about the NSA - the U.S. government National Security Agency",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS xkcd_nav_block  %]
[% PROCESS foss_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ol>

<li>
<p>
<a href="[% base_path %]humour.html#yo-nsa-publish-or-perish">“Yo
NSA, Publish or Perish!”</a> - captioned image by me.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/fortunes/show.cgi?id=smg-next-film">“Sarah
Michelle Gellar’s Next Movie”</a> - old fortune cookie.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/fortunes/show.cgi?id=kilmo-about-the-NSA">“kilmo
about the NSA”</a> - a sequel to the previous fortune cookie.
</p>
</li>

<li>
<p>
<a href="smg-film/">Open Letter to Ms. Sarah Michelle Gellar regarding
the production of the film “Summerschool at the NSA”</a> - another
sequel - somewhat more serious.
</p>
</li>

<li>
<p>
<a href="http://unarmed.shlomifish.org/2615.html">Blog Post:
“‘Publish or Perish’ → ‘Life or Death’”</a> - discusses why keeping secrets
to yourself is a recipe for disaster.
</p>
</li>

<li>

<p>
<a href="[% base_path %]humour/Summerschool-at-the-NSA/"><i>Summerschool
at the NSA</i> - a screenplay</a>:
</p>

<blockquote>

[% long_stories.calc_abstract(id => 'summerschool_at_the_nsa') %]

</blockquote>

</li>

[% PROCESS li_SummerNSA_hashtag %]

<li>
<p>
<a href="https://plus.google.com/+ShlomiFish/posts/gyrcAfAASev">Google+ Post:
Why Summer Glau Will Be The Next Warrior Queen</a>
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Summer-Glau/">Summer Glau Facts</a>
</p>
</li>

<li>
<p>
<a href="https://plus.google.com/+ShlomiFish/posts/WM5nxzKGdqj">Google+
Post: “Why
paranoid security and misery causes one's downfall?”</a> - corresponding the
Knights Templar whom Saladin fought, to today's NSA.
</p>
</li>

<li>
<p>
<a href="https://plus.google.com/+ShlomiFish/posts/i5Z8XdqTdwE">“Summer Glau
for Government! [And I'm Not Joking As the Reader Shall See]”</a> - on Google+.
</p>
</li>

<li>
<p>
<a href="https://www.shlomifish.org/me/rindolf/#update_long_live_us_hacker_monarchs">Update: Long Live,
us, [no-"the"!] Hacker Monarchs!</a>
</p>
</li>

<li>
<p>
<a href="http://shlomifishswiki.branchable.com/Saladin_Style/">“Saladin
Style”</a> - an executive summary — irresponsible and opinionated — about
Saladin’s innovative approach to security, combat warfare, psychological
warfare, and justice, that still has implications today.
</p>
</li>

</ol>
EOF
        short_id   => 'nsa',
        tabs_title => "NSA Facts",
        title      => "NSA Facts",
        url_base   => "NSA",
    },
    {
        abstract => <<'EOF',
<p>
<a href="https://en.wikipedia.org/wiki/Summer_Glau">Summer Glau</a> (born
1981) is a Hollywood actress best known for playing
<a href="http://firefly.wikia.com/wiki/River_Tam">River Tam</a> in
<i>Firefly</i>
and <a href="http://terminator.wikia.com/wiki/Cameron">Cameron</a>,
a Terminator, in the
Television series <i>The Sarah Connor Chronicles</i>. She
is also notable for being featured in the online comics,
<a href="https://en.wikipedia.org/wiki/Xkcd">xkcd</a>, and for being featured
as a fictional version of herself in the realistic, political, fan-fiction,
screenplay, <a href="[% base_path %]humour/Summerschool-at-the-NSA/"><i>Summerschool
at the NSA</i></a>.
</p>

<p>
Glau is notable for being the first non-fictional and <b>real-life female</b>,
who is the subject of such facts here.
</p>

EOF
        id_base         => "summer_glau_facts",
        img_alt         => "Photo of Summer Glau from the English Wikipedia",
        img_attribution =>
'https://en.wikipedia.org/wiki/Summer_Glau#mediaviewer/File:Summer_Glau_by_Gage_Skidmore.jpg',
        img_class      => "facts_logo summer_glau",
        img_src        => "humour/bits/facts/images/sglau-150w.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2014",
        links_tt2      => <<'EOF',
<ul>

[% PROCESS summer_glau_common_links %]

</ul>
EOF
        meta_desc      => "Factoids about Summer Glau, the Hollywood actress",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS xkcd_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ul>

[% PROCESS summer_glau_see_also %]

</ul>
EOF
        short_id   => 'sglau',
        tabs_title => "Summer Glau Facts",
        title      => "Summer Glau Facts",
        url_base   => "Summer-Glau",
    },
    {
        abstract => <<'EOF',
<p>
Facts about <a href="https://en.wikipedia.org/wiki/Taylor_Swift">Taylor Swift</a>,
a 1989-born American singer-songwriter, who is known for her narrative songs,
her extravagant music videos, her philanthropy, and the rich culture of
YouTubers who cover, parody, and remix her songs.
</p>
EOF
        id_base         => "taylor_swift_facts",
        img_alt         => "Photo of Taylor Swift from the Wikipedia",
        img_attribution =>
            'https://en.wikipedia.org/wiki/File:TaylorSwiftApr09.jpg',
        img_class      => "facts_logo taylor_swift",
        img_src        => "humour/bits/facts/images/tayswift-small.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2019",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="https://www.youtube.com/watch?v=nfWlot6h_JM">Shake it Off</a>
</p>
</li>

</ul>
EOF
        meta_desc =>
"Factoids about Taylor Swift, the singer-songwriter and entertainer",
        nav_blocks_tt2 => <<'EOF',
EOF
        see_also => <<'EOF',
<ul>
<li>
<p>
<a href="[% base_path %]humour/fortunes/show.cgi?id=sharp-gnu--think-big">#gnu conversation</a> that started the Taylor Swift facts trend.
</p>
</li>

<li>
<p>
<a href="[% base_path %]philosophy/culture/my-real-person-fan-fiction/#taylor_swift">Taylor Swift as an amateur</a>
</p>
</li>

<li>
<p>
<a href="[% base_path %]philosophy/philosophy/putting-cards-on-the-table-2019-2020/#Taylor_Swift">Taylor Swift as a Hacker Queen</a>
</p>
</li>

</ul>
EOF
        short_id   => 'taylor_swift',
        tabs_title => "Taylor Swift Facts",
        title      => "Taylor Swift Facts",
        url_base   => "Taylor-Swift",
    },
    {
        abstract => <<'EOF',
<p>
<a href="http://en.wikipedia.org/wiki/Windows_Update">Windows Update</a> is
a service offered by Microsoft to update components of its software.
</p>

<p>
These facts illustrate how horribly slow Windows Update is and how it is
annoying to use.
</p>

EOF
        id_base         => "windows_update_facts",
        img_alt         => "Silhouette of a Snail",
        img_attribution =>
            'https://openclipart.org/detail/230426/snail-silhouette',
        img_class      => "facts_logo windows_update",
        img_src        => "humour/bits/facts/images/snail.min.svg",
        license_method => "by_sa_british_blurb",
        license_year   => "2016",
        links_tt2      => <<'EOF',
EOF
        meta_desc =>
"Facts about Windows Update, the slowest and most frutrating package manager in existence.",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS foss_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<ul>

<li>
<p>
<a href="https://tonsky.me/blog/disenchantment/">Software disenchantment</a> -
highlights Windows Update’s slowness.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/fortunes/show.cgi?id=sharp-programming-windows-update">Windows Update</a> - IRC
Log.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/fortunes/show.cgi?id=sharp-programming-windows-UpHate">“Windows UpHate”</a> -
<q>It's recently caused people to miss out on large parts of their exams</q>
</p>
</li>

</ul>
EOF
        short_id   => 'windows_update',
        tabs_title => "Windows Update Facts",
        title      => "Windows Update Facts",
        url_base   => "Windows-Update",
    },
    {
        abstract => <<'EOF',
<p>
After reading the
<a href="http://en.wikipedia.org/wiki/Chuck_Norris_facts">Wikipedia
page about Chuck Norris Facts</a> (and related facts), I was saddened to learn
that there were none about females. So, in the name of gender equality,
a collection of facts about
<a href="http://en.wikipedia.org/wiki/Xena">Xena, the Warrior Princess</a>
was created.
</p>

<p>
I recall watching the show and enjoying it, though I found it a little silly.
I also found the character of Xena to be more comical than strong.
</p>
EOF
        id_base         => "xena_facts",
        img_alt         => "Photo of Xena, the Warrior Princess",
        img_attribution =>
'http://images6.fanpop.com/image/photos/35900000/Xena-big-size-xena-warrior-princess-35948592-3112-4688.jpg',
        img_class      => "facts_logo xena",
        img_src        => "humour/bits/facts/images/xena-small.webp",
        license_method => "by_sa_british_blurb",
        license_year   => "2009",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://unarmed.shlomifish.org/2396.html">“About
Female Action Heroes”</a> - my post as response to <a href="http://actionflickchick.com/superaction/wired-interviews-the-action-flick-chick-geek-cultures-26-most-awesome-female-ass-kickers/">a post about an interview with
Action Flick Chick about Geek Culture’s 26 Most Awesome
Female Ass-Kickers</a>.
</p>
</li>
</ul>
EOF
        meta_desc      => "Factoids about Xena, the Warrior Princess",
        nav_blocks_tt2 => <<'EOF',
EOF
        see_also => <<'EOF',
<ul>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Clarissa/">Clarissa Darling Facts</a> - about
another pre-Buffy heroine.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Buffy/">Buffy Facts</a> - facts about Buffy
herself.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Chuck-Norris/">Additions to
Chuck Norris Facts</a> - more toughness.
</p>
</li>

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Summer-Glau/">Summer Glau Facts</a> - about
a real-life female.
</p>
</li>

</ul>
EOF
        short_id   => 'xena',
        tabs_title => "Xena Facts",
        title      => "Xena (the Warrior Princess) Facts",
        url_base   => "Xena",
    },
    {
        abstract => <<'EOF',
<p>
<a href="http://en.wikipedia.org/wiki/XSL_Transformations">XSLT</a> is
short for Extensible Stylesheet Language (XSL) Transformations and is
an XML-based language for transforming XML documents into other XML
documents.
</p>

<p>
These facts illustrate how <b>evil</b> XSLT (supposedly) is.
</p>

<p>
I think XSLT
has many legitimate uses and can be pretty sweet, but
<a href="[% base_path %]humour/fortunes/show.cgi?id=sharp-sharp-programming-why-XSLT-is-so-evil">an
IRC conversation we had on ##programming</a> started this meme and it
seems cool.
</p>
EOF
        id_base         => "xslt_facts",
        img_alt         => "XSLT Logo",
        img_attribution =>
'https://github.com/shlomif/shlomi-fish-homepage/blob/master/src/humour/bits/facts/images/XSLT.svg',
        img_class      => "facts_logo xslt",
        img_src        => "humour/bits/facts/images/XSLT.min.svg",
        license_method => "by_sa_british_blurb",
        license_year   => "2009",
        links_tt2      => <<'EOF',
<ul>

<li>
<p>
<a href="http://perl-begin.org/uses/xml/#xslt">XSLT Resources for Perl</a> -
refers to several resources.
</p>
</li>

<li>
<p>
<a href="[% base_path %]open-source/anti/SOAP/">“Links against SOAP”</a>
- links to resources about a really evil XML technology.
</p>
</li>

</ul>
EOF
        meta_desc      => "Facts about XSLT, the most Evil thing in existence.",
        nav_blocks_tt2 => <<'EOF',
[% WRAPPER nav_blocks  %]
[% PROCESS foss_nav_block  %]
[%- END -%]
EOF
        see_also => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
        short_id   => 'xslt',
        tabs_title => "XSLT Facts",
        title      => "XSLT Facts",
        url_base   => "XSLT",
    },
);

sub _page_to_obj
{
    my ($hash_ref) = @_;

    my $ret;
    eval { $ret = Shlomif::Homepage::FactoidsPages::Page->new($hash_ref); };

    if ($@)
    {
        print "Failed at " . $hash_ref->{id_base} . "!\n";
        die $@;
    }

    return $ret;
}

# Chuck at the beginning. In Soviet Russia at the end.
my @pages_proto = ( @chuck_pages, @main_pages, @soviet_pages );

my @pages = ( map { _page_to_obj($_); } @pages_proto );

my $TT2__FACTS_BLOCKS_TT_TEXT = <<'END_OF_TEMPLATE';
[% PROCESS "Inc/emma_watson.tt2" %]

{{ FOREACH p IN pages }}
[% BLOCK facts__img__{{ p.short_id() }} %]

<!-- Taken from {{ p.img_attribution() }} -->

<img src="{{ p.img_src_tt2() }}" alt="{{ p.img_alt() }}" class="{{ p.img_class() }}" />
[% END %]
[% BLOCK facts__{{ p.short_id() }} %]

<div class="facts_wrap">
[% INCLUDE facts__img__{{ p.short_id() }}%]

<div class="desc">
{{ p.abstract() }}
</div>

</div>

[% END %]
{{ END }}

[% BLOCK facts__list %]
{{ FOREACH p IN pages }}
[% WRAPPER h3_section id="facts-{{ p.short_id() }}" sect_class="facts" href="{{ p.url_base() }}" title="{{ p.title() }}" %]
{{ "[% INCLUDE facts__${p.short_id()} %]" }}

[% END %]
{{ END }}
[% END %]
END_OF_TEMPLATE

my $TT2__TT_TEXT = <<'END_OF_TEMPLATE';
[% SET title = "{{p.title() }}" %]
[% SET desc = "{{p.meta_desc()}}" %]

[% WRAPPER wrap_html %]

[% PROCESS "Inc/emma_watson.tt2" %]
[% PROCESS "Inc/factoids_jqui_tabs_multi_lang.tt2" %]
[% PROCESS "Inc/nav_blocks.tt2" %]
[% PROCESS "Inc/summer_glau.tt2" %]
[% PROCESS "factoids/common-out/tags.tt2" %]
[% PROCESS "stories/stories-list.tt2" %]


[% INCLUDE facts__{{ p.short_id() }} %]

[% INCLUDE facts__header_tabs id_base="{{ p.id_base() }}" h="{{ p.tabs_title() }}" %]

[% WRAPPER h2_section id="license" title="Copyright and Licence"%]

[% license_obj.{{ p.license_method() }} (year=>"{{ p.license_year() }}") %]

[% END %]

[% WRAPPER links_sect  %]

{{ p.links_tt2() }}

[% END %]

[% WRAPPER see_also  %]

{{ p.see_also() }}

[% END %]

{{ p.nav_blocks_tt2() }}

[% END %]
END_OF_TEMPLATE

# some useful options (see below for full list)
my $config = {
    POST_CHOMP => 1,    # cleanup whitespace
    EVAL_PERL  => 1,    # evaluate Perl code blocks
};

# create Template object
my $tt2__template =
    Template->new( +{ %$config, START_TAG => "\\{\\{", END_TAG => "\\}\\}", } );

sub _write_processed
{
    my ( $TT2, $vars, $path ) = @_;
    $tt2__template->process(
        $TT2, $vars,
        sub {
            my ($out_str) = @_;

            write_on_change( scalar( path($path) ), \$out_str, );
        }
    ) or die $!;

    return;
}

foreach my $page (@pages)
{
    _write_processed(
        \$TT2__TT_TEXT,
        { p => $page, },
        "lib/factoids/pages/" . $page->id_base() . '.tt2'
    );
}

_write_processed(
    \$TT2__FACTS_BLOCKS_TT_TEXT,
    { pages => \@pages, },
    "lib/factoids/common-out/tags.tt2",
);

my $new_json = JSON::MaybeXS->new(
    utf8      => 1,
    canonical => 1
)->encode(
    [
        map {
            my $page = $_;
            +{
                url  => "humour/bits/facts/" . $page->url_base . "/",
                text => $page->title,
            }
        } @pages
    ]
);

my $json_fn = 'lib/Shlomif/factoids-nav.json';

write_on_change_no_utf8( scalar( path($json_fn) ), \$new_json, );

sub _content__process_page
{
    my ($page) = @_;

    my $id   = $page->id_base;
    my $path = $page->url_base;
    my $pre_incs_path =
        "dest/pre-incs/t2/humour/bits/facts/${path}/index.xhtml";
    return [
        +{
            'path' => $pre_incs_path,
            line   => "$pre_incs_path: "
                . join( " ", uniqstr( sort @{ $deps{$id} } ) ) . "\n",
        },
    ];
}

my @content =
    map { @{ _content__process_page($_) }; }
    sort { $a->short_id cmp $b->short_id } @pages;

path("lib/factoids/deps.mak")
    ->spew_utf8( join( " ", "all:", map { $_->{path} } @content ) . "\n",
    ( map { $_->{line} } @content ) );

# No write_on_change() because we want it to have the time of the last run.
path("lib/factoids/TIMESTAMP")->spew_utf8( time() );

__END__

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Shlomi Fish.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
