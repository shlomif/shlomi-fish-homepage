#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 1;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content = path("$T2_POST_DEST/images/bk2hp-v2.min.svg")->slurp_utf8;

    # TEST
    like( $content, qr{<svg}, 'Contains a tag.' );
}
