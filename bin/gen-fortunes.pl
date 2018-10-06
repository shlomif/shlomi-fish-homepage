#!/usr/bin/perl

use strict;
use warnings;

use Cwd qw(getcwd);

{
    my $orig_dir = getcwd();

    chdir("t2/humour/fortunes");

    if ( -e 'friends' )
    {
        system( "gmake", "-s", "dist" );
    }

    chdir($orig_dir);
}
