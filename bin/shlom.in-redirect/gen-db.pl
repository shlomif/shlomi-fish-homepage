#!/usr/bin/env perl

use 5.014;
use strict;
use warnings;
use utf8;

my @urls = (
    {
        id  => "intro-lang",
        url =>
"http://www.shlomifish.org/philosophy/computers/education/introductory-language/",
        desc => "Thoughts about the Best Introductory Programming Language"
    },
    {
        id   => "hp",
        url  => "http://www.shlomifish.org/",
        desc => "Shlomi Fish's Homepage",
    },
    {
        id   => "enemy",
        url  => "http://www.shlomifish.org/humour/TheEnemy/",
        desc => "The Enemy and How I Helped to Fight it",
    },
    {
        id   => "humanity",
        url  => "http://www.shlomifish.org/humour/humanity/",
        desc => "Humanity - The Movie",
    },
    {
        id   => "sussman",
        url  => "http://www.shlomifish.org/open-source/interviews/sussman.html",
        desc => "Interview with Ben Collins-Sussman",
    },
    {
        id  => "optimise",
        url =>
"http://www.shlomifish.org/philosophy/computers/optimizing-code-for-speed/",
        desc => "Optimising Code for Speed",
    },
    {
        id   => "towtf",
        url  => "http://www.shlomifish.org/humour/TOneW-the-Fountainhead/",
        desc => "The One With the Fountainhead",
    },
    {
        id  => "rethinking-cpan",
        url => "http://use.perl.org/use.perl.org/_petdance/journal/36073.html",

        # "http://perlbuzz.com/2008/04/rethinking-the-interface-to-cpan.html",
        desc => "Rethinking CPAN",
    },
    {
        id  => "st-wtld",
        url => "http://www.shlomifish.org/humour/Star-Trek/We-the-Living-Dead/",
        desc => qq{Star Trek: "We, the Living Dead"},
    },
    {
        id   => "selina",
        url  => "http://www.shlomifish.org/humour/Selina-Mandrake/",
        desc => qq{Selina Mandrake - The Slayer},
    },
    {
        id   => "file-swap",
        url  => "http://www.shlomifish.org/philosophy/case-for-file-swapping/",
        desc => qq{The Case for File Swapping},
    },
    {
        id   => "hhfg",
        url  => "http://www.shlomifish.org/humour/human-hacking/",
        desc => qq{The Human Hacking Field Guide},
    },
    {
        id   => "oss-fs",
        url  => "http://www.shlomifish.org/philosophy/foss-other-beasts/",
        desc => qq{Open Source, Free Software and Other Beasts},
    },
    {
        id   => "def-zionism",
        url  => "http://www.shlomifish.org/philosophy/politics/define-zionism/",
        desc => qq{Define "Zionism"},
    },
    {
        id  => "sw-quality",
        url =>
"http://www.shlomifish.org/philosophy/computers/high-quality-software/",
        desc => qq{What Makes Software High-Quality?},
    },
    {
        id  => "joy-of-perl",
        url =>
            "http://www.shlomifish.org/philosophy/computers/perl/joy-of-perl/",
        desc => qq{The Joy of Perl},
    },
    {
        id  => "gpl-bsd-sucker",
        url =>
"http://www.shlomifish.org/philosophy/computers/open-source/gpl-bsd-and-suckerism/",
        desc => qq{The GPL, The BSD Licence and Being a Sucker},
    },
    {
        id  => "perfect-workplace",
        url =>
"http://www.shlomifish.org/philosophy/computers/software-management/perfect-workplace/",
        desc => qq{The Perfect Info-Tech Workplace},
    },
    {
        id  => "sourceware",
        url =>
"http://www.shlomifish.org/philosophy/foss-other-beasts/revision-2/foss-and-other-beasts/criteria.html#criteria_sourceware",
        desc => qq{Open source vs. Sourceware},
    },
    {
        id  => "closed-books",
        url =>
"http://www.shlomifish.org/philosophy/philosophy/closed-books-are-so-19th-century/",
        desc => qq{Why Closed Books are So 19th-Century},
    },
    {
        id   => "reply",
        url  => "http://www.shlomifish.org/meta/FAQ/#reply_to_list",
        desc => qq{Reply to the list.},
    },
    {
        id   => "port-libs",
        url  => "http://www.shlomifish.org/open-source/portability-libs/",
        desc => qq{List of Cross-Platform, Abstraction, Portability Libraries},
    },
    {
        id  => "IDEs",
        url =>
            "http://www.shlomifish.org/open-source/resources/editors-and-IDEs/",
        desc => qq{List of Text Editors and IDEs},
    },
    {
        id  => "text-proc",
        url =>
"http://www.shlomifish.org/open-source/resources/text-processing-tools/",
        desc => qq{List of Text Processing Tools},
    },
    {
        id  => "net-clients",
        url =>
"http://www.shlomifish.org/open-source/resources/networking-clients/",
        desc => qq{List of Networking Clients},
    },
    {
        id   => "sglau-facts",
        url  => "http://www.shlomifish.org/humour/bits/facts/Summer-Glau/",
        desc => qq{Summer Glau Facts},
    },
    {
        id   => "emwatson-facts",
        url  => "http://www.shlomifish.org/humour/bits/facts/Emma-Watson/",
        desc => qq{Emma Watson Facts},
    },
    {
        id   => "qoheleth",
        url  => "http://www.shlomifish.org/humour/So-Who-The-Hell-Is-Qoheleth/",
        desc => qq{“So, Who the Hell is Qoheleth?”},
    },
    {
        id  => 'setup',
        url =>
'https://raw.githubusercontent.com/shlomif/shlomif-computer-settings/master/shlomif-settings/setup-all/setup-all.pl',
        desc => qq{My setup script — for quick access},
    },
    {
        id  => "graphics",
        url =>
"https://www.shlomifish.org/open-source/resources/graphics-programs/",
        desc => qq{List of Graphics Applications},
    },
    {
        id  => "geekyhackers",
        url =>
"https://www.shlomifish.org/philosophy/culture/case-for-commercial-fan-fiction/indiv-nodes/hacking_and_amateur__vs__conformism_and_professional.xhtml",
        desc =>
qq{Commercial Real Person Fan Fiction (RPFs), crossovers and parodies as 2021 geek/hacker imperatives for revitalising the film industry (Full Version) - Hacking and Amateur/Geekdom vs. Conformism and Professionalism},
    },
);

my %urls_by_id;
my %data_by_id;

while ( my ( $idx, $rec ) = each(@urls) )
{
    if ( !( $rec->{id} && $rec->{url} && $rec->{desc} ) )
    {
        print "Ask Shlomi Fish to fix record No. $idx [ id = $rec->{id} ]\n";
        exit(1);
    }
    if ( exists( $urls_by_id{ $rec->{id} } ) )
    {
        print "Ask Shlomi Fish to fix record No. $idx [ id = $rec->{id} ]\n";
        exit(1);
    }
    $urls_by_id{ $rec->{id} } = $rec->{url};
    $data_by_id{ $rec->{id} } = $rec;
}
use Data::Dumper;
$Data::Dumper::Terse    = 1;
$Data::Dumper::Indent   = 0;
$Data::Dumper::Sortkeys = 1;

use Path::Tiny qw/ path tempdir tempfile cwd /;

path("D.pm")->spew_utf8( "\$U=", Dumper( \%urls_by_id ), ";\n1;" );
path("A.pm")
    ->spew_utf8( "use utf8;\n", "\$A=", Dumper( \%data_by_id ), ";\n1;" );

$::A = \%data_by_id;
my $table = '';
for my $k ( sort keys %$::A )
{
    my $rec = $::A->{$k};
    my $d   = $rec->{desc};
    my $url = $rec->{url};
    $table .=
qq!<tr><td><p><a href="$url">https://shlom.in/$k</a></p></td><td class="full"><p><a href="$url">$url</a></p></td><td><p>$d</p></td></tr>!;
}
my $title =
"Welcome to http://shlom.in/ , the private short URL service of Shlomi Fish";
path("front.txt")->spew_utf8( <<"EOF" =~ s#[\n\r]##gmrs );
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>$title</title>
<meta charset="utf-8"/>
<style>
td, th
{
    border: solid 1pt darkgreen;
    padding: 0.5em;
    text-align: left;
    vertical-align: top;
}
</style>
</head>
<body>

<h1>$title</h1>

<p>
This domain serves as <a href="http://www.shlomifish.org/">Shlomi Fish's</a>
<b>non-public</b> URL shortening service. As such, it is fully under his
control, does not have a convenient web-interface to add more links, and
cannot be used to redirect to spam links. Therefore, I ask you not to block
it in spam filters.
</p>

<p>
There is a list of public URLs that are pointed by this
service, below. For more information please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>.
</p>

<table>
<tr>
<th>Short URL</th>
<th>Full URL</th>
<th>Description</th>
</tr>
$table
</table>

<p>
( <a href="https://github.com/shlomif/shlomi-fish-homepage/tree/master/bin/shlom.in-redirect"><b>GitHub Source</b></a>. )
</p>

</body>
</html>
EOF
