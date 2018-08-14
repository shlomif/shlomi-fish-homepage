#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;

{
    # TEST
    like(
        scalar(`gmake T2_SOFTWARE_DOCS_SRC.show`),
        qr% \Qt2/open-source/index.html.wml\E %,
        "found a file"
    );
}
