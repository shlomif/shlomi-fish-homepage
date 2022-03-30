#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;

use Test::File::IsSorted ();

# TEST
Test::File::IsSorted::are_sorted(
    [
        ".gitignore",
        "lib/make/asciidocs2db5-source.mak",
        "lib/make/copies-source.mak",
        "lib/Shlomif/Homepage/captioned-images.txt",
    ],
    "Files are sorted",
);
