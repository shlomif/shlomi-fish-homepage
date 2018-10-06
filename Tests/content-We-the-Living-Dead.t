#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;
use Path::Tiny qw/ path /;
use lib './lib';
use Shlomif::Homepage::Paths;

my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

{
    my $content =
        path(
        "$T2_POST_DEST/humour/Star-Trek/We-the-Living-Dead/ongoing-text.html")
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
