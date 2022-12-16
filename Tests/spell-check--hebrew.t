#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Test::More;

if ( ( $ENV{SKIP_SPELL_CHECK} // '' ) =~ m#(?:\A|,)he(?:,|\z)#ms )
{
    plan skip_all => 'Skipping spell check due to environment variable';
}
else
{
    plan tests => 1;
}

use Shlomif::Spelling::Hebrew::Iface ();

# TEST
Shlomif::Spelling::Hebrew::Iface->new->test_spelling("No spelling errors.");
