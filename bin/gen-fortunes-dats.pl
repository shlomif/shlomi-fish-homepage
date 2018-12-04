#!/usr/bin/env perl

use strict;
use warnings;

use Cwd qw(getcwd);

{
    my $orig_dir = getcwd();

    chdir("t2/humour/fortunes");

    system( "gmake", "-s", "dats" );

    chdir($orig_dir);
}
