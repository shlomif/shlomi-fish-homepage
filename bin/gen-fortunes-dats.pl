#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

sub _exec
{
    my ( $cmd, $err ) = @_;

    if ( system(@$cmd) )
    {
        die $err;
    }
    return;
}

_exec(
    [
        qw#gmake -s -j16 -f lib/make/factoids.mak src/humour/fortunes/shlomif-factoids.xml #
    ],
    'gmake -f lib/make/factoids.mak'
);
_exec( [qw#gmake -s -j16 -C src/humour/fortunes dats#], 'gmake -C' );
