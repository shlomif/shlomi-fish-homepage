#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use IO::All;

my $out_fn;

GetOptions(
    "output|o=s" => \$out_fn,
);

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

my $text = scalar(io()->file($filename)->slurp());

$text =~ s{<(/?h)(\d+)}{"<".$1.($2+1)}ge;

$text =~ s{\A.*?(<div class="screenplay")}{$1}ms;
substr($text, rindex($text, "</div>")) = "</div>";

io()->file($out_fn)->print($text);

