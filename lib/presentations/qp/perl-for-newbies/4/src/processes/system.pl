#!/usr/bin/perl

use strict;
use warnings;

(system("ls -l /") == 0)
    or die "system 'ls -l /' failed - $?";

my @args = ("ls", "-l", "/");
(system(@args) == 0)
    or die "Could not ls -l / - $?";

(system("ls -l | grep ^d | wc -l") == 0)
    or die "Could not pipeline - $?";
