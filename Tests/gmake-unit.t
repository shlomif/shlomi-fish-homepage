#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 4;

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

    # TEST
    like(
        scalar(`gmake SCREENPLAY_XML_HTMLS.show`),
        qr% \Qlib/screenplay-xml/html/TOW_Fountainhead_1.html\E %,
        "found a file"
    );

    # TEST
    like(
        scalar(`gmake DOCBOOK4_PDFS.show`),
        qr% \Qlib/docbook/4/pdf/what-makes-software-high-quality-rev2.pdf\E %,
        "found a file"
    );
}
