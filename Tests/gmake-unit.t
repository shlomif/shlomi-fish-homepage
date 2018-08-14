#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 2;

{
    # TEST
    like(
        scalar(`gmake T2_SOFTWARE_DOCS_SRC.show`),
        qr% \Qt2/open-source/index.html.wml\E %,
        "found a file"
    );

    # TEST
    like(
        scalar(`gmake T2_HUMOUR_DOCS_DEST.show`),
        qr% \Qdest/t2/humour.html\E %,
        "found a file"
    );
}
