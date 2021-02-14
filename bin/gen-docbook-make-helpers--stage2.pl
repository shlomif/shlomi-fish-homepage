#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Carp ();
use Path::Tiny qw/ path /;
use lib './lib';
use Shlomif::Homepage::Git               ();
use Shlomif::Homepage::GenScreenplaysMak ();

my $gen_scr_ret = Shlomif::Homepage::GenScreenplaysMak->new->generate(
    { git_task => sub { return ''; }, } );

path("lib/make/docbook/sf-screenplays.mak")
    ->append_utf8( map { $_->() }
        ( @{ $gen_scr_ret->{generate_file_list_promises} } ) );
