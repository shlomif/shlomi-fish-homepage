#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny qw/ path /;

{
    # TEST
    like( path("./dest/t2/index.html")->slurp_utf8,
qr#<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />#
    );
}
