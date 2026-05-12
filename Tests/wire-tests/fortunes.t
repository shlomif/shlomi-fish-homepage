#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;
use lib './Tests/lib/';
use Shlomif::FortunesWireTests ();

{
    my $base = $ENV{BASE_URL};

    # TEST
    Shlomif::FortunesWireTests->new( { base_url => qq[$base] } )->run();
}
