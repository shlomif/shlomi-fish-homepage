#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;
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

{
    # TEST
    cmp_ok( scalar( -s "$POST_DEST/humour/fortunes/fortunes-shlomif-all.atom" ),
        '>', 100, "size of .atom file" );

    # TEST
    cmp_ok( scalar( -s "$POST_DEST/humour/fortunes/fortunes-shlomif-all.rss" ),
        '>', 100, "size of .rss file" );

    # TEST
    ok( scalar( !-e "$POST_DEST/humour/fortunes/fortunes-shlomif.spec" ),
        "existence of .spec file" );

    # TEST
    cmp_ok( scalar( -s "$POST_DEST/humour/fortunes/fortunes_show.py" ),
        '>', 100, "size of .py file" );
}
