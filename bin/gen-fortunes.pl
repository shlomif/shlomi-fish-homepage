#!/usr/bin/perl

use strict;
use warnings;

use Cwd qw(getcwd);

# This is to in order to generate the t2/humour/fortunes/arcs-list.mak
# file, which is inclduded by the makefile.
{
    my $orig_dir = getcwd();

    chdir("t2/humour/fortunes");
    system("make", "dist"); 
    system("make", "list_files");

    chdir($orig_dir);
}

