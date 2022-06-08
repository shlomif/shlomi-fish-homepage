package Shlomif::Homepage::FactoidsPages::Data;

use strict;
use warnings;
use utf8;

use Moo;

sub calc_data
{
    my ( $self, ) = @_;

    my @chuck_pages = (
        {
            abstract => <<'EOF',
<p>
These are additions to the
<a href="https://en.wikipedia.org/wiki/Chuck_Norris_facts">Chuck
Norris facts</a> trend by my Internet friends and by me. Most of them are
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
            id_base => "chuck_facts",
            img_alt => "Photo of Chuck Norris from the English Wikipedia",
            img_attribution =>
                'http://en.wikipedia.org/wiki/File:Norrishuckabee.JPG',
            img_class => "facts_logo chuck_norris",
            img_src   => "humour/bits/facts/images/chuck-norris-1-150w.webp",
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
<a href="https://www.youtube.com/watch?v=ZrHmcpRAZNs">“Hitler Finds out Chuck Norris is Coming”</a> - video on YouTube.
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
            img_src => "humour/bits/facts/images/soviet-union-modified.min.svg",
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
            meta_desc            => "In Soviet Russia, jokes laugh at you.",
            override_html_anchor => 'soviet-russia',
            see_also             => <<'EOF',
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
            img_attribution =>
                'http://en.wikipedia.org/wiki/File:S514_Buffy.png',
            img_class => "facts_logo buffy",
            img_src   =>
                "humour/bits/facts/images/SMG-as-buffy-from-wikipedia.webp",
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
            meta_desc =>
                "Facts about Buffy Summers from Buffy the Vampire Slayer",
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

<li>
<p>
<a href="[% base_path %]humour/bits/facts/Summer-Glau/">Summer Glau Facts</a> -
about a real-life female.
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
            id_base => "clarissa_facts",
            img_alt => "Photo of the First DVD of CEIA from the Wikipedia",
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
            title => "Clarissa Darling (from Clarissa Explains it All) Facts",
            url_base => "Clarissa",
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
            meta_desc => "Factoids about Emma Watson, the British actress",
            see_also  => <<'EOF',
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
            override_html_anchor => 'larry-wall-fact',
            see_also             => <<'EOF',
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

<blockquote cite="">

<p>[Discussing the shortage of IT workers as of 1998 on E-mail]</p>

<p>Shlomi Fish to Omer Zak: “Even the NSA doesn’t have enough programmers. But
it is not likely that they will have more, and that’s because <i>Summerschool
at the NSA</i> may might as well be the name of Sarah Michelle Gellar’s next
movie.” </p>

<p>Omer Zak to Shlomi Fish: “And as opposed to <i>I Know What You Did Last
Summer</i>, it is going to be scary.” </p>

</blockquote>

</li>

<li>
<p>
<a href="[% base_path %]humour/fortunes/show.cgi?id=kilmo-about-the-NSA">“kilmo
about the NSA”</a> - a sequel to the previous fortune cookie.
</p>

<blockquote cite="">

<blockquote>

<p> [Discussing the shortage of IT workers as of 1998 on
E-mail] </p>

<p> Shlomi Fish to Omer Zak: "Even the NSA doesn’t have
enough programmers. But it is not likely that they will
have more and that’s because ‘Summerschool at the NSA’
may might as well be the name of Sarah Michelle
Gellar’s next movie." </p>

<p> Omer Zak to Shlomi Fish: "And as opposed to ‘I Know
What You Did Last Summer’ it is going to be scary."
</p>

</blockquote>

<p> <b>Kilmo:</b> why would you like to make fun of the
crypto world ? ;) The NSA does know what you did last
summer.  And by putting this on the web, they know that you
know.  </p>


<p> Which may lead to interesting philosophical issues. BTW, in
a conference I was attending we were given a sticker
saying: "NSA - free email backup".  </p>


<p> They still have some issue with the retrieval procedures,
but besides of that  - they are quite a trusted service.  </p>

<p> <b>Shlomi Fish:</b> In my case, I think every random Joe can learn a
lot about me. Even if he’s not in Google or the NSA or whatever.  </p>

<p> <b>Kilmo:</b> Yep. But this is a world-wide service that
they offer. (Along with several co-operations, like MI5/6).
</p>

</blockquote>

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
            id_base => "sglau_facts",
            img_alt => "Photo of Summer Glau from the English Wikipedia",
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
            meta_desc => "Factoids about Summer Glau, the Hollywood actress",
            see_also  => <<'EOF',
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

<li>
<p>
<a href="https://www.youtube.com/watch?v=Zlot0i3Zykw">"Red"</a> - a song Swift
wrote about her relationship with her mind's hell-hole's echo of me: a static site owner
who was critical of her songs, while being enamoured with many YouTube musicians
especially <a href="https://en.wikipedia.org/wiki/Christina_Grimmie">Christina
Grimmie</a> and <a href="https://en.wikipedia.org/wiki/Tiffany_Alvord">Tiffany Alvord</a>.
She used www.shlomifish.org as fodder for her songs.
</p>
</li>
</ul>
EOF
            meta_desc =>
"Factoids about Taylor Swift, the singer-songwriter and entertainer",
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
            override_html_anchor => 'win-update',
            see_also             => <<'EOF',
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

<li>

<p>
<a href="[% base_path %]philosophy/culture/case-for-commercial-fan-fiction/#starved_of_employees">"Businesses Being Starved of Competent Employees"</a>:
</p>

<blockquote cite="">

[% PROCESS "Inc/microsoft_deprecating.tt2" %]
[% INCLUDE mswin_deprecate %]

</blockquote>

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
Female Action Heroes”</a> - my post as response to
<a href="http://actionflickchick.com/superaction/wired-interviews-the-action-flick-chick-geek-cultures-26-most-awesome-female-ass-kickers/">a post about an interview with
Action Flick Chick about Geek Culture’s 26 Most Awesome
Female Ass-Kickers</a>.
</p>
</li>
</ul>
EOF
            meta_desc => "Factoids about Xena, the Warrior Princess",
            see_also  => <<'EOF',
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
            meta_desc => "Facts about XSLT, the most Evil thing in existence.",
            see_also  => <<'EOF',
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

    # Chuck at the beginning. In Soviet Russia at the end.
    my @pages_proto = ( @chuck_pages, @main_pages, @soviet_pages );

    return +{ pages_proto => \@pages_proto, };
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
