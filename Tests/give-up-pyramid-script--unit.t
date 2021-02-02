#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;
use lib './lib';

sub script_test
{
    my ( $prefix, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $output =
qx#"$^X" -E 'while (1) { say "Give up" . (" giving up" x (\$i++)) . "!"; }' | head -n 100#;
    $output =~ s#\r##g;
    return is( substr( $output, 0, length($prefix) ), $prefix, $blurb );
}

{
    # TEST
    script_test( "Give up!\n", "1 line" );
}
