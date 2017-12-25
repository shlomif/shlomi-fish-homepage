#!/usr/bin/perl

use strict;
use warnings;

use lib './lib';

use Shlomif::Spelling::Check;

Shlomif::Spelling::Check->new()->spell_check(
    {
        files => \@ARGV,
    },
);
