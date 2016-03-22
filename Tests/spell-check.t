#!/usr/bin/perl

use strict;
use warnings;

use lib './lib';

use Test::More tests => 1;

use Shlomif::Spelling::Iface;

# TEST
Shlomif::Spelling::Iface->new->test_spelling("No spelling errors.");
