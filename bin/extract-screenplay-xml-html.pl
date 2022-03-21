#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use IO::All;

my $out_fn;

GetOptions( "output|o=s" => \$out_fn, );

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

my $text = scalar( io()->file($filename)->utf8()->slurp() );

$text =~ s{<(/?h)(\d+)}{"<".$1.($2+1)}ge;

$text =~ s{\A.*?(<main class="screenplay")}{$1}ms;
substr( $text, rindex( $text, "</main>" ) ) = "</main>";

io()->file($out_fn)->utf8()->print($text);

