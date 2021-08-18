#! /usr/bin/env perl
#
# Short description for zip-compare.pl
#
# Version 0.0.1
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

my $l = <>;
chomp $l;
if ( my @r = $l =~ m#\ABinary files (/(?:\S+)) and (/(?:\S+)) differ\z#ms )
{
    my @d = ( '_from', '_to' );
    foreach my $dir (@d)
    {
        $dir = path($dir);
        $dir->remove_tree;
        $dir->mkpath;
        system( "cd $dir && unzip " . shift(@r) );
    }
    system("diff -u -r @d");
}
else
{
    die "invalid pattern";
}
