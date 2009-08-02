#!/usr/bin/perl

use strict;
use warnings;

my $pyramid_side = 20;

open O, ">", "pyramid.txt";
for($a=1 ; $a <= $pyramid_side ; $a++)
{
    print O "X" x $a;
    print O "\n";
}
close(O);
