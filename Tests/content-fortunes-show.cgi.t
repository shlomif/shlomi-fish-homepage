#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 2;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $fh = path("$POST_DEST/humour/fortunes/show.cgi");

    # TEST
    ok( -x $fh, "show.cgi is executable." );

    # TEST
    like( $fh->slurp_utf8, qr%\A#!.{50}%ms, "shebang is present" );
}
