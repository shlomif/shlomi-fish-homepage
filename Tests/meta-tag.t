#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny qw/ path /;

{
    my $H_RE = qr#\s*http-equiv="Content-Type"\s*#;
    my $C_RE = qr#\s*content="text/html; charset=utf-8"\s*#;

    # TEST
    like(
        path("./post-dest/t2/index.html")->slurp_utf8,
        qr#<meta (?:(?:$H_RE$C_RE)|(?:$C_RE$H_RE))/>#
    );
}
