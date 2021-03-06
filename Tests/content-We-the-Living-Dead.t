#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content =
        path("$POST_DEST/humour/Star-Trek/We-the-Living-Dead/ongoing-text.html")
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

{
    my $content =
        path(
"$POST_DEST/humour/Queen-Padme-Tales/Queen-Padme-Tales--Queen-Amidala-vs-the-Klingon-Warriors.html"
    )->slurp_utf8;

    # TEST
    like( $content, qr{<div class="screenplay"}, 'Contains a screenplay div.' );

    # TEST
    like( $content, qr{podracer}i, 'Contains "podracer".' );
}
