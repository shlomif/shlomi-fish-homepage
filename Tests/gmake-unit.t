#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 10;
use lib './lib';
use Shlomif::Homepage::Paths;

my $T2_DEST      = Shlomif::Homepage::Paths->new->t2_dest;
my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

sub gmake_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return like( scalar(`gmake $var.show`),
        qr%(?:\A| )\Q$word\E(?:\n|\z| )%ms, $blurb, );
}

sub dest_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return gmake_test( $var, "$T2_DEST/$word", $blurb );
}

{
    # TEST
    gmake_test( 'T2_SOFTWARE_DOCS_SRC', 't2/open-source/index.xhtml.wml',
        "found a file" );

    # TEST
    dest_test( 'T2_HUMOUR_DOCS_DEST', 'humour.html', "found a file" );

    # TEST
    dest_test(
        'SCREENPLAY_SOURCES_ON_DEST',
'humour/So-Who-The-Hell-Is-Qoheleth/So-Who-The-Hell-Is-Qoheleth.screenplay-text.txt',
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
    dest_test( 'DEST_ZIP_MODS', 'Iglu/shlomif/mods/dreams2.xm.zip',
        "found a file" );

    # TEST
    dest_test( 'DEST_XZ_MODS', 'Iglu/shlomif/mods/focus.mod.xz',
        "found a file" );

    # TEST
    gmake_test( 'T2_POST_DIRS_DEST', "$T2_POST_DEST/art/original-graphics",
        "found a dir" );

    # TEST
    dest_test( 'ALL_HTACCESSES', 'humour/fortunes/.htaccess', ".htaccess" );

    # TEST
    dest_test( 'ALL_HTACCESSES', 'open-source/.htaccess', ".htaccess" );
}
