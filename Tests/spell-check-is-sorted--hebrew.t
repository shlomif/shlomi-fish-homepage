#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use lib './lib';

use Shlomif::Spelling::Hebrew::Whitelist ();

# TEST
ok( Shlomif::Spelling::Hebrew::Whitelist->new->is_sorted(),
    "Whitelist file is sorted." )
    or diag(
    "Whitelist file is not sorted! Please run ./bin/sort-check-spelling-file");
