#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use MyMath::Ops::Add;

{
    my $adder = MyMath::Ops::Add->new();

    # TEST
    ok ($adder, "Adder was initialised");

    # TEST
    is ($adder->add(2,3), 5, "2+3 == 5");
}
