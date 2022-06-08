#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;

use Test::File::IsSorted v0.2.0 ();

# TEST
Test::File::IsSorted::are_sorted2(
    [
        ".gitignore",
        "lib/Shlomif/Homepage/captioned-images.txt",
        "lib/make/asciidocs2db5-source.mak",
        "lib/make/copies-source.mak",
    ],
    "Files are sorted",
);
