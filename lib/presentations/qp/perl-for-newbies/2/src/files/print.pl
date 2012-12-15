#!/usr/bin/perl

use strict;
use warnings;

my $pyramid_side = 20;

open my $out, ">", "pyramid.txt";
for ($l=1 ; $l <= $pyramid_side ; $l++)
{
    print {$out} "X" x $l;
    print {$out} "\n";
}
close($out);
