#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use lib './lib';
use HTML::Latemp::Local::Paths ();

use Test::More tests => 1;
use Path::Tiny qw/ path /;

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;
{
    my $content =
        path("$T2_POST_DEST/lecture/Vim/beginners/slides/slide24.html")
        ->slurp_utf8;

    # TEST
    like( $content, qr/<body/, "vim talk slides" );
}
