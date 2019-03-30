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

_exec( [qw#gmake -s -j16 -C t2/humour/fortunes dats#], 'gmake' );
