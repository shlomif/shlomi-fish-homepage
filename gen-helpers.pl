#!/usr/bin/env perl

use strict;
use warnings;

if ( system( "make", "--silent", "-f", "lib/make/build-deps/build-deps.mak" ) )
{
    die "build-deps failed!";
}

system( $^X, './bin/gen-helpers-main.pl' )
    and die "gen-helpers-main.pl failed.";
