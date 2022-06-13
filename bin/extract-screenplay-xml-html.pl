#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long qw/ GetOptions /;
use Path::Tiny   qw/ path /;

my $out_fn;

GetOptions( "output|o=s" => \$out_fn, );

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

my $text = path($filename)->slurp_utf8;

$text =~ s{<(/?h)([0-9])}{"<".$1.($2+1)}ge;

$text =~ s{\A.*?(<)main( class="screenplay")}{$1 . "div" . $2}ems;
substr( $text, rindex( $text, "</main>" ) ) = "</div>";

path($out_fn)->spew_utf8($text);
