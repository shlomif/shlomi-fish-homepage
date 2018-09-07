#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny qw/ path /;

{
    my $H_RE     = qr#\s*http-equiv="Content-Type"\s*#;
    my $C_RE     = qr#\s*content="text/html; charset=utf-8"\s*#;
    my $HTML5_RE = qr#\s*charset="utf-8"\s*#;

    # TEST
    like(
        path("./post-dest/t2/index.xhtml")->slurp_utf8,
        qr#<meta (?:$HTML5_RE|(?:(?:$H_RE$C_RE)|(?:$C_RE$H_RE)))/>#
    );
}
