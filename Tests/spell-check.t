#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

{
    my $output = `./bin/spell-checker-iface`;
    chomp($output);

    # TEST
    is ($output, '', "No spelling errors.");
}
