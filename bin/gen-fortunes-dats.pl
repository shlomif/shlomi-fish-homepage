#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use lib './lib';
use Shlomif::MySystem qw/ my_system /;

my_system(
    [
        qw#gmake -s -j16 -f lib/make/factoids.mak src/humour/fortunes/shlomif-factoids.xml #
    ],
    'gmake -f lib/make/factoids.mak'
);
my_system( [qw#gmake -s -j16 -C src/humour/fortunes dats#], 'gmake -C' );

foreach my $dat ( glob("src/humour/fortunes/*.dat") )
{
    my $orig = $dat =~ s/\.dat\z//r;
    my $time = ( ( stat $orig ) )[9] + 1;
    utime( $time, $time, $dat );
}
