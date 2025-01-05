#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use lib './lib';

use Getopt::Long qw/ GetOptions /;
use Path::Tiny   qw/ path /;

use Shlomif::DocBookClean ();

my $out_fn;

GetOptions( "output|o=s" => \$out_fn, );

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

{
    my $s = path($filename)->slurp_utf8;

    Shlomif::DocBookClean::cleanup_docbook( \$s, $filename, );

    $s =~ s{\A.*?<body[^>]*>}{}ms;
    $s =~ s{</body>.*\z}{}ms;

    my %to_process = ( map { $_ => 1 } split /\n+/, <<'EOF' );
A-hashtag-SummerNSA-s-Reading
SummerNSA-2014-09-call-for-action
case-for-drug-legalisation--hebrew-v3
case-for-drug-legalisation-v3
case-for-file-swapping-rev3
dealing-with-hypomanias
end-of-it-slavery
foss-licences-wars
human-hacking-field-guide-v2--english
introductory-language
my-real-person-fiction
objectivism-and-open-source
perfect-it-workplace
putting-all-cards-on-the-table-2013
putting-cards-on-the-table-2019-2020
what-makes-software-high-quality
what-makes-software-high-quality-rev2
why-openly-bipolar-people-should-not-be-medicated
EOF

    # Fixed in Perl 6...
    if ( $out_fn =~ m#/([^/]+)\.xhtml\z# and exists( $to_process{$1} ) )
    {
        # $s =~ s#<h1[^>]*>The Human Hacking Field Guide</h1>##g;
        # $s =~ s{<(/?)h([3-6])}{"<".$1."h".($2-1)}ge;
        $s =~ s{<(/?)h([1])}{"<".$1."h".($2+1)}ge;
    }
    else
    {
        $s =~ s{<(/?)h([0-9])}{"<".$1."h".($2+1)}ge;
    }

    $s =~ s/[ \t]+$//gms;
    path($out_fn)->spew_utf8($s);
}
