#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use lib './lib';
use HTML::Latemp::Local::Paths ();

use Test::More tests => 2;
use Path::Tiny qw/ path /;

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;
{
    my $content = path("$POST_DEST/MANIFEST.html")->slurp_utf8;

    # TEST
    like( $content, qr#<a href="humour/fortunes/\.htaccess">#, "MANIFEST" );

    # TEST
    unlike(
        $content,
        qr#<a href="humour/fortunes/[^"]+\.tar\.gz">#,
        "MANIFEST fortunes tarball"
    );
}
