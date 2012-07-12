#!/usr/bin/perl

use strict;
use warnings;

my $pyramid_side = 20;

open my $out, ">", "pyramid.txt";
for($a=1 ; $a <= $pyramid_side ; $a++)
{
    print {$out} "X" x $a;
    print {$out} "\n";
}
close($out);
