#! /usr/bin/env perl
#
# Short description for spell-whitelist.pl
#
# Version 0.0.1
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;
use utf8;

use Path::Tiny qw/ path tempdir tempfile cwd /;

my %words;

my @lines = path("foo.txt")->lines_utf8();
chomp @lines;

my ( $start, $end ) = @ARGV;

foreach my $lidx ( $start .. $end )
{
    my $l = $lines[ $lidx - 1 ];

    my ( $fn, $rest ) = $l =~ m#\A([^:]+):[0-9]+:(.*)\z#ms
        or die "lidx=$lidx";
    my @m = ( $rest =~ m#«([^»]+)»#g );
    foreach my $w (@m)
    {
        $w =~ s#\A«##ms;
        $w =~ s#»\z##ms;
        ++$words{$w}{$fn};
    }
}

my $out;
foreach my $w ( sort keys %words )
{
    $out .=
        "\n==== In: " . join( ' , ', sort keys %{ $words{$w} } ) . "\n\n$w\n";
}

path("lib/hunspell/whitelist1.txt")->append_utf8($out);

system("./bin/sort-check-spelling-file");
