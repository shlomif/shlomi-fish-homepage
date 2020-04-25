#! /usr/bin/env perl
#
# Short description for inkscape-wrapper-old.pl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
# Copyright (C) 2020 Shlomi Fish <shlomif@cpan.org>
#
use strict;
use warnings;
use 5.014;
use autodie;

system(
    "inkscape",
    (
        map {
                  /\A--export-type=png\z/      ? ()
                : /\A--export-filename=(.*)\z/ ? ("--export-png=$1")
                : ($_)
        } @ARGV
    ),
) and die $!;
