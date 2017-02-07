#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Test::More tests => 5;

use IO::All qw/io/;

{
    my $content = io->file(
        "./dest/t2/humour/Star-Trek/We-the-Living-Dead/ongoing-text.html")
        ->utf8->all;

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
