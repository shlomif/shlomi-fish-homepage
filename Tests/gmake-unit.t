#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 4;

sub gmake_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return like( scalar(`gmake $var.show`), qr% \Q$word\E %, $blurb, );
}

{
    # TEST
    gmake_test( 'T2_SOFTWARE_DOCS_SRC', 't2/open-source/index.html.wml',
        "found a file" );

    # TEST
    gmake_test( 'T2_HUMOUR_DOCS_DEST', 'dest/t2/humour.html', "found a file" );

    # TEST
    gmake_test(
        'SCREENPLAY_XML_HTMLS',
        'lib/screenplay-xml/html/TOW_Fountainhead_1.html',
        "found a file"
    );

    # TEST
    gmake_test( 'DOCBOOK4_PDFS',
        'lib/docbook/4/pdf/what-makes-software-high-quality-rev2.pdf',
        "found a file" );
}
