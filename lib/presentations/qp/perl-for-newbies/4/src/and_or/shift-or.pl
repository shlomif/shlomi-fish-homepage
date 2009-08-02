#!/usr/bin/perl

use strict;
use warnings;


# shift by default shifts from @ARGV in the main program
my $start = shift || 1;
my $end = shift || ($start+9);

for my $i ($start .. $end)
{
    print "$i\n";
}

