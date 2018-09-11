#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 10;

sub gmake_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return like( scalar(`gmake $var.show`),
        qr%(?:\A| )\Q$word\E(?:\n|\z| )%ms, $blurb, );
}

{
    # TEST
    gmake_test( 'T2_SOFTWARE_DOCS_SRC', 't2/open-source/index.xhtml.wml',
        "found a file" );

    # TEST
    gmake_test( 'T2_HUMOUR_DOCS_DEST', 'dest/pre-incs/t2/humour.html',
        "found a file" );

    # TEST
    gmake_test(
        'SCREENPLAY_SOURCES_ON_DEST',
'dest/pre-incs/t2/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-The-Hell-Is-Qoheleth.screenplay-text.txt',
        "SCREENPLAY_SOURCES_ON_DEST - Qoheleth",
    );

    # TEST
    gmake_test(
        'SCREENPLAY_XML_HTMLS',
        'lib/screenplay-xml/html/TOW_Fountainhead_1.html',
        "found a file"
    );

    # TEST
    gmake_test( 'DOCBOOK4_PDFS', 'lib/docbook/4/pdf/the-eternal-jew.pdf',
        "found a file" );

    # TEST
    gmake_test( 'DEST_ZIP_MODS',
        'dest/pre-incs/t2/Iglu/shlomif/mods/dreams2.xm.zip',
        "found a file" );

    # TEST
    gmake_test( 'DEST_XZ_MODS',
        'dest/pre-incs/t2/Iglu/shlomif/mods/focus.mod.xz',
        "found a file" );

    # TEST
    gmake_test( 'T2_POST_DIRS_DEST', 'post-dest/t2/art/original-graphics',
        "found a dir" );

    # TEST
    gmake_test( 'ALL_HTACCESSES', 'dest/pre-incs/t2/humour/fortunes/.htaccess',
        ".htaccess" );

    # TEST
    gmake_test( 'ALL_HTACCESSES', 'dest/pre-incs/t2/open-source/.htaccess',
        ".htaccess" );
}
