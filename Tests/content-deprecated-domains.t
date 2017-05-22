#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Test::More tests => 1;
use Test::Differences (qw(eq_or_diff));

{
    # TEST
    eq_or_diff( scalar(`ag -i 'penguin\\.org\\.il' ./dest`),
        '', "No deprecated (hijacked/etc.) domains." );
}
