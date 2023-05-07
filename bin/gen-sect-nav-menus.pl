#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Path::Tiny                           qw/ path /;
use Parallel::Map::Segmented             ();
use Shlomif::Homepage::GenSectionNavMenu ();

my $gen = Shlomif::Homepage::GenSectionNavMenu->new();

Parallel::Map::Segmented->new()->run(
    {
        items => [
            ( split /\n/, path("lib/make/generated/tt2.txt")->slurp_raw() ),
        ],
        nproc         => 4,
        batch_size    => 16,
        process_batch => sub { return $gen->process_batch(@_); },
        (
              ( delete( $ENV{LATEMP_PROFILE} ) || $ENV{TRAVIS} )
            ? ( disable_fork => 1, )
            : ()
        ),
    }
);
