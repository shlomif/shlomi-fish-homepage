#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
use Path::Tiny qw/ path /;

{
    my $content =
        path(
        "./post-dest/t2/humour/Star-Trek/We-the-Living-Dead/ongoing-text.html")
        ->slurp_utf8;

    # TEST
    like( $content, qr{<div class="screenplay"}, 'Contains a screenplay div.' );

    # TEST
    like( $content, qr{\bBashir}, 'Contains a name from the screenplay.' );

    # TEST
    like( $content, qr{\bKatie}, 'Contains a name from the screenplay.' );

    # TEST
    like( $content, qr{\bKira}, 'Contains a name from the screenplay.' );

    # TEST
    like( $content, qr{\bDax}, 'Contains a name from the screenplay.' );
}
