#!/usr/bin/perl

use strict;
use warnings;

sub create_counter
{
    my $counter = 0;

    my $counter_func = sub {
        return ($counter++);
    };

    return $counter_func;
}

my @counters = (create_counter(), create_counter());

# Initialize the random number generator to a constant value;
srand(24);

for my $i (1 .. 100)
{
    # This call generates a random number that is either 0 or 1
    my $which_counter = int(rand(2));

    my $value = $counters[$which_counter]->();

    print "$which_counter = $value\n";
}


