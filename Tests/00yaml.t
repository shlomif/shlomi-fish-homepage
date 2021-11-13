#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

my @files = `git ls-files | grep -E '\\.ya?ml\$'`;
chomp @files;

# TEST
is(
    (
        system(
            qw%prettier --parser yaml --arrow-parens always --tab-width 4 --trailing-comma all -c%,
            (
                grep {
                    !(
                           m#\A\.(?:act-)?github#
                        or
m#\.travis\.yml|fortunes-shlomif-ids-data|JSON_Data_Persistence#
                    )
                } @files
            ),
        ) & 0xFF
    ),
    0,
    "YAMLs are formatted fine",
);
