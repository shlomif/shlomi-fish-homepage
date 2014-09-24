#!/usr/bin/perl

use strict;
use warnings;

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
        }
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

    $template->process(\$tt_text, $vars, "lib/factoids/pages/". $page->id_base().'.wml');
}
