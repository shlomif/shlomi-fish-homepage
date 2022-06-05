#! /usr/bin/env perl
#
# Short description for build.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

while (1)
{
    system("./gen-helpers.pl");
    my $txt = `make 2>&1`;
    say $txt;
    if ( my ($fn) =
        $txt =~
m#^cp: cannot create regular file 'dest/t2-homepage/([^'\n]+)/[^/\n]+'#ms
        )
    {
        system("git mkdir t2/$fn");
    }
    else
    {
        die;
    }
}
