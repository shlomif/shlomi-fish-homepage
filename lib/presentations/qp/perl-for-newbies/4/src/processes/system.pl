#!/usr/bin/perl

use strict;
use warnings;

system("ls -l /");

my @args = ("ls", "-l", "/");
system(@args);

system("ls -l | grep ^d | wc -l");

