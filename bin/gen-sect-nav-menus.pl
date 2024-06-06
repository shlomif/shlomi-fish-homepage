#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Parallel::Map::Segmented             ();
use Path::Tiny                           qw/ path /;
use Shlomif::Homepage::GenSectionNavMenu ();

my $gen = Shlomif::Homepage::GenSectionNavMenu->new();

my @SQLITE_REQUIRED_OPTIONS = ( disable_fork => 1, );

Parallel::Map::Segmented->new()->run(
    {
        batch_size => 16,
        items      => [
            ( split /\n/, path("lib/make/generated/tt2.txt")->slurp_raw() ),
        ],
        nproc         => 1,
        process_batch => sub { return $gen->process_batch(@_); },
        @SQLITE_REQUIRED_OPTIONS,
        (
              ( delete( $ENV{LATEMP_PROFILE} ) || $ENV{TRAVIS} )
            ? ( disable_fork => 1, )
            : ()
        ),
    }
);

$gen->end_();
