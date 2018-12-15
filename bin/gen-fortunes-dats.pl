#!/usr/bin/env perl

use strict;
use warnings;

use Cwd qw(getcwd);

sub _exec
{
    my ( $cmd, $err ) = @_;

    if ( system(@$cmd) )
    {
        die $err;
    }
    return;
}

{
    my $orig_dir = getcwd();

    chdir("t2/humour/fortunes");

    _exec( [ "gmake", "-s", "dats" ], 'gmake' );

    chdir($orig_dir);
}
