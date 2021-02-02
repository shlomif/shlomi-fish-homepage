#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 3;
use lib './lib';

sub script_test
{
    my ( $prefix, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $output =
qx#"$^X" -E 'while (1) { say "Give up" . (" giving up" x (\$i++)) . "!"; }' | head -n 100#;
    $output =~ s#\r##g;
    return is(
        substr( $output, 0, length($prefix) ),
        $prefix, "Terminator Liberation perl script - $blurb",
    );
}

{
    # TEST
    script_test( "Give up!\n", "1 line" );

    # TEST
    script_test( "Give up!\nGive up giving up!\n", "2 lines", );

    # TEST
    script_test( "Give up!\nGive up giving up!\nGive up giving up giving up!\n",
        "3 lines", );
}
