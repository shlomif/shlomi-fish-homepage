#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths::Test ();

my $obj       = HTML::Latemp::Local::Paths::Test->new();
my $POST_DEST = $obj->t2_post_dest();

{
    my $fh = path("$POST_DEST/humour/fortunes/show.cgi");

    # TEST
    ok( -x $fh, "show.cgi is executable." );

    # TEST
    like( $fh->slurp_utf8, qr%\A#!.{50}%ms, "shebang is present" );
}

{
    # TEST
    $obj->_check_size("humour/fortunes/fortunes-shlomif-all.atom");

    # TEST
    $obj->_check_size("humour/fortunes/fortunes-shlomif-all.rss");

    # TEST
    ok( scalar( !-e "$POST_DEST/humour/fortunes/fortunes-shlomif.spec" ),
        "existence of .spec file" );

    # TEST
    $obj->_check_size("humour/fortunes/fortunes_show.py");

    # TEST
    $obj->_check_size("humour/fortunes/fortunes-shlomif.epub");
}
