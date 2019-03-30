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

chdir("t2/humour/fortunes");
_exec( [ "gmake", "-s", "-j16", "dats" ], 'gmake' );
