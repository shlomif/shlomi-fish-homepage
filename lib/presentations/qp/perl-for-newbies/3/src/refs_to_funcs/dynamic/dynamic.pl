#!/usr/bin/perl

use strict;
use warnings;
my $increment;

{
    my $counter;
    # The definition of a dynamic reference to function comes inside
    # a "sub {" ... "}" closure
    $increment = sub {
        print $counter, "\n";
        return $counter++;
    };
}

while ($increment->() < 100)
{
    # Do Nothing
}

