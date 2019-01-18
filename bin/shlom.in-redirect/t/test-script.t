#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;

{
    # TEST
    is(
        scalar(`REDIRECT_URL=/graphics $^X shlom.in-refer.pl`),
qq#Status: 301\r\nLocation: https://www.shlomifish.org/open-source/resources/graphics-programs/\r\n\r\n#,
        "graphics link.",
    );
}
