#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny qw/ path /;
use lib './lib';
use Shlomif::Homepage::Paths;

my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

{
    my $H_RE     = qr#\s*http-equiv="Content-Type"\s*#;
    my $C_RE     = qr#\s*content="text/html; charset=utf-8"\s*#;
    my $HTML5_RE = qr#\s*charset="utf-8"\s*#;

    # TEST
    like( path("$T2_POST_DEST/index.xhtml")->slurp_utf8,
        qr#<meta (?:$HTML5_RE|(?:(?:$H_RE$C_RE)|(?:$C_RE$H_RE)))/># );
}
