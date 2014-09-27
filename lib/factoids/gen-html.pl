#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use lib './lib';

use IO::All qw/ io /;

use XML::LibXML;
use XML::LibXML::XPathContext;

use XML::Grammar::Fortune;
use Template;

use Shlomif::Homepage::FactoidsPages::Page;

my $p = XML::LibXML->new;

my $xslt_path = XML::Grammar::Fortune->new->dist_path_slot("to_html_xslt_transform_basename");

my $facts_xml_path = './lib/factoids/shlomif-factoids-lists.xml';

my $dom = $p->parse_file($facts_xml_path);

# print map { $_->value , "\n" } $dom->findnodes("//list/\@xml:id");

foreach my $list_node ( $dom->findnodes("//list/\@xml:id") )
{
    foreach my $lang (qw(en-US he-IL))
    {
        my $list_id = $list_node->value;

        my $basename = "$list_id--$lang";
        my $out_xhtml =  "./lib/factoids/indiv-lists-xhtmls/$basename.xhtml";
        system(
            "xsltproc", "--output", $out_xhtml,
            "--stringparam", 'filter-facts-list.id', $list_id,
            "--stringparam", 'filter.lang', $lang,
            $xslt_path, $facts_xml_path,
        );

        my $indiv_dom = $p->parse_file($out_xhtml);

        my $xpc = XML::LibXML::XPathContext->new($indiv_dom);
        $xpc->registerNs('xhtml', "http://www.w3.org/1999/xhtml" );

        my $node = $xpc->findnodes("//xhtml:div[\@class='main_facts_list']")->[0];

        io->file("$out_xhtml.reduced")->utf8->print(
            $node->toString =~ s/\s+xmlns:xsi="[^"]+"//gr
        );
    }
}

my @pages =
(
    map
    { Shlomif::Homepage::FactoidsPages::Page->new($_); }
    (
        {
            id_base => 'buffy_facts',
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2013" />
EOF
            links_wml => <<'EOF',
<ul>

<li>
<p>
<a href="http://buffy.wikia.com/">Buffy the Vampire Slayer and Angel Wiki</a>
- a wiki about the show and the Buffy universe.
</p>
</li>

<li>
<p>
<a href="http://buffyfanfiction.wikia.com/">Buffy Fanfiction Wikia</a>
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
            nav_blocks_wml => <<'EOF',
<buffy_nav_block />
EOF
            see_also_wml => <<'EOF',
<ul>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Xena/">Xena Facts</a> - facts about Xena
the Warrior Princess (another tough chick).
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Clarissa/">Clarissa Darling Facts</a> - about
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
<a href="$(ROOT)/humour/Selina-Mandrake/"><i>Selina Mandrake
- The Slayer</i></a> - my own Buffy parody/anti-thesis/modernisation.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/Buffy/A-Few-Good-Slayers/"><i>Buffy: A Few
Good Slayers</i></a> - a work-in-progress screenplay that is a more traditional
Buffy fanfic. Set in a fork of the Buffy universe, and takes place in 2014/2015
Sunnydale, where the Scooby Gang are adults, married men and women, parents,
and teachers/mentors.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/Summerschool-at-the-NSA/"><i>Summerschool
at the NSA</i></a> - another screenplay with a strong Buffy/Sarah Michelle
Gellar theme.
</p>
</li>

</ul>
EOF
            short_id => 'buffy',
            tabs_title => 'Buffy Facts',
            title => 'Buffy Facts',
        },
        {
            id_base => "chuck_facts",
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2010" />
EOF
            links_wml => <<'EOF',
<ul>

<li>
<p>
<a href="http://www.chucknorrisfacts.com/">Main Chuck Norris facts site</a> -
with thousands of factoids.
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
href="$(ROOT)/philosophy/philosophy/putting-all-cards-on-the-table-2013/">“Putting
all the Cards on the Table (2013)”</a> (also by me) - mentions what is the
second major battle that Chuck Norris lost.
</p>
</li>

</ul>
EOF
            meta_desc => "Additional Chuck Norris Factoids by Shlomi Fish and Friends. No one is as tough as Norris.",
            nav_blocks_wml => <<'EOF',
<foss_nav_block />
EOF
            see_also_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
            short_id => 'chuck',
            tabs_title => "Chuck Norris Facts",
            title => "Chuck Norris Facts",
        },
        {
            id_base => "clarissa_facts",
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2013" />
EOF
            links_wml => <<'EOF',
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
            meta_desc => "Clarissa Darling facts (from Clarissa Explains it All) - what you would not imagine about this smart cookie.",
            nav_blocks_wml => <<'EOF',

EOF
            see_also_wml => <<'EOF',
<ul>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Xena/">Xena Facts</a> -
about another pre-Buffy heroine.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Buffy/">Buffy Facts</a> - facts about Buffy
herself.
</p>
</li>

</ul>
EOF
            short_id => 'clarissa',
            tabs_title => "Clarissa Darling Facts",
            title => "Clarissa Darling Facts (from Clarissa Explains it All)",
        },
        {
            id_base => "emma_watson_facts",
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2014" />
EOF
            links_wml => <<'EOF',
<ul>

<emma_watson_common_links />

</ul>
EOF
            meta_desc => "Factoids about Emma Watson, the British actress",
            nav_blocks_wml => <<'EOF',
<harry_potter_nav_block />
EOF
            see_also_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
            short_id => 'emma_watson',
            tabs_title => "Emma Watson Facts",
            title => "Emma Watson Facts",
        },
        {
            id_base => "in_soviet_russia_facts",
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2013" />
EOF
            links_wml => <<'EOF',
<ul>

<li>
<p>
<a href="https://en.wikipedia.org/wiki/Russian_reversal">Russian
reversal (“In Soviet Russia”) on the Wikipedia</a>
</p>
</li>

</ul>
EOF
            meta_desc => "In Soviet Russia, jokes laugh at you.",
            nav_blocks_wml => <<'EOF',

EOF
            see_also_wml => <<'EOF',
<ul>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Chuck-Norris/">Chuck Norris Facts</a> -
another popular Internet meme.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/NSA/">NSA facts</a> - more
anti-authoritarianism stuff.
</p>
</li>

</ul>
EOF
            short_id => 'in_soviet_russia',
            tabs_title => "“In Soviet Russia” Aphorisms",
            title => "“In Soviet Russia” Additions",
        },
        {
            id_base => "larry_wall_facts",
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2007" />
EOF
            links_wml => <<'EOF',
<ul>

<li>
<p>
<a href="http://en.wikiquote.org/wiki/Larry_Wall">Larry Wall Quotes on Wikiquote</a>
</p>
</li>

</ul>
EOF
            meta_desc => "Factoids about Larry Wall, the creator of the Perl programming language, and the UNIX patch utility.",
            nav_blocks_wml => <<'EOF',
<foss_nav_block />
EOF
            see_also_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
            short_id => 'lwall',
            tabs_title => "Larry Wall Facts",
            title => "Larry Wall Facts",
        },
        {
            id_base => "knuth_is_not_god_facts",
            license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2002" />
EOF
            links_wml => <<'EOF',
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
            meta_desc => "Why Prof. Don Knuth (= the famous computer scientist) is not God, but is pretty close.",
            nav_blocks_wml => <<'EOF',
<foss_nav_block />
EOF
            see_also_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
            short_id => 'knuth',
            tabs_title => "Why Knuth is Not God",
            title => "Knuth Facts",
        },
        {
            id_base => "nsa_facts",
            license_wml => <<'EOF',
<cc_by_british_blurb year="2013" />
EOF
            links_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
            meta_desc => "Factoids about the NSA - the U.S. government National Security Agency",
            nav_blocks_wml => <<'EOF',
<xkcd_nav_block />
<foss_nav_block />
EOF
            see_also_wml => <<'EOF',
<ol>

<li>
<p>
<a href="$(ROOT)/humour.html#yo-nsa-publish-or-perish">“Yo
NSA, Publish or Perish!”</a> - captioned image by me.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/fortunes/show.cgi?id=smg-next-film">“Sarah
Michelle Gellar’s Next Movie”</a> - old fortune cookie.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/fortunes/show.cgi?id=kilmo-about-the-NSA">“kilmo
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
<a href="$(ROOT)/humour/Summerschool-at-the-NSA/"><i>Summerschool
at the NSA</i> - a screenplay</a>:
</p>

<blockquote>

<: Shlomif::Homepage::LongStories->render_abstract('summerschool_at_the_nsa'); :>

</blockquote>

</li>

<li_SummerNSA_hashtag />

<li>
<p>
<a href="https://plus.google.com/+ShlomiFish/posts/gyrcAfAASev">Google+ Post:
Why Summer Glau Will Be The Next Warrior Queen</a>
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Summer-Glau/">Summer Glau Facts</a>
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
<a href="https://en.wikipedia.org/wiki/User:Shlomif/Saladin_Style">“Saladin
Style”</a> - an executive summary — irresponsible and opinionated — about
Saladin’s innovative approach to security, combat warfare, psychological
warfare, and justice, that still has implications today.
</p>
</li>

</ol>
EOF
short_id => 'nsa',
tabs_title => "NSA Facts",
title => "NSA Facts",
},
{
id_base => "summer_glau_facts",
license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2014" />
EOF
links_wml => <<'EOF',
<ul>

<summer_glau_common_links />

</ul>
EOF
meta_desc => "Factoids about Summer Glau, the Hollywood actress",
nav_blocks_wml => <<'EOF',
<xkcd_nav_block />
EOF
see_also_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
short_id => 'sglau',
tabs_title => "Summer Glau Facts",
title => "Summer Glau Facts",
},
{
id_base => "xena_facts",
license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2009" />
EOF
links_wml => <<'EOF',
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
meta_desc => "Factoids about Xena, the Warrior Princess",
nav_blocks_wml => <<'EOF',

EOF
see_also_wml => <<'EOF',
<ul>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Clarissa/">Clarissa Darling Facts</a> - about
another pre-Buffy heroine.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Buffy/">Buffy Facts</a> - facts about Buffy
herself.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/humour/bits/facts/Chuck-Norris/">Additions to
Chuck Norris Facts</a> - more toughness.
</p>
</li>

</ul>
EOF
short_id => 'xena',
tabs_title => "Xena Facts",
title => "Xena (the Warrior Princess) Facts",
},
{
id_base => "xslt_facts",
license_wml => <<'EOF',
<cc_by_sa_british_blurb year="2009" />
EOF
links_wml => <<'EOF',
<ul>

<li>
<p>
<a href="http://perl-begin.org/uses/xml/#xslt">XSLT Resources for Perl</a> -
refers to several resources.
</p>
</li>

<li>
<p>
<a href="$(ROOT)/open-source/anti/SOAP/">“Links against SOAP”</a>
- links to resources about a really evil XML technology.
</p>
</li>

</ul>
EOF
meta_desc => "Facts about XSLT, the most Evil thing in existence.",
nav_blocks_wml => <<'EOF',
<foss_nav_block />
EOF
see_also_wml => <<'EOF',
<p>
<b>TODO</b>
</p>
EOF
short_id => 'xslt',
tabs_title => "XSLT Facts",
title => "XSLT Facts",
        },
    ),
);

foreach my $page (@pages)
{
    # some useful options (see below for full list)
    my $config =
    {
        POST_CHOMP   => 1,               # cleanup whitespace
        EVAL_PERL    => 1,               # evaluate Perl code blocks
    };

    # create Template object
    my $template = Template->new($config);

    my $vars =
    {
        p => $page,
    };

    my $tt_text = <<'END_OF_TEMPLATE';
#include '../template.wml'

#include "Inc/emma_watson.wml"
#include "Inc/factoids_jqui_tabs_multi_lang.wml"
#include "Inc/nav_blocks.wml"
#include "Inc/summer_glau.wml"
#include "stories/facts.wml"
#include "stories/stories-list.wml"
#include "utils.wml"

<latemp_subject "[% p.title() %]" />
<latemp_meta_desc "[% p.meta_desc() %]" />

<facts__[% p.short_id() %] />

<facts__header_tabs id_base="[% p.id_base() %]" h="[% p.tabs_title() %]" />

<h2 id="license">Copyright and Licence</h2>

[% p.license_wml() %]

<h2 id="links">Links</h2>

[% p.links_wml() %]

<h2 id="see_also">See Also</h2>

[% p.see_also_wml() %]

[% p.nav_blocks_wml() %]
END_OF_TEMPLATE

    my $out = '';
    $template->process(\$tt_text, $vars, \$out);
    io->file("lib/factoids/pages/". $page->id_base().'.wml')->utf8->print($out);
}
