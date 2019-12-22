#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 7;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $PRE_DEST  = HTML::Latemp::Local::Paths->new->t2_dest;
my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

delete $ENV{MAKEFLAGS};

sub gmake_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return like( scalar(`gmake $var.show`),
        qr%(?:\A| )\Q$word\E(?:\n|\z| )%ms, $blurb, );
}

sub post_dest_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return gmake_test( $var, "$POST_DEST/$word", $blurb );
}

sub dest_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return gmake_test( $var, "$PRE_DEST/$word", $blurb );
}

{
    # TEST
    gmake_test( 'DOCBOOK5_EPUB_DIR', 'lib/docbook/5/epub',
        "DOCBOOK5_EPUB_DIR" );

    # TEST
    post_dest_test(
        'SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS',
'humour/So-Who-The-Hell-Is-Qoheleth/So-Who-The-Hell-Is-Qoheleth.screenplay-text.txt',
        "SCREENPLAY_SOURCES_ON_DEST__EXTRA_TARGETS - Qoheleth",
    );

    # TEST
    gmake_test(
        'SCREENPLAY_XML_HTMLS',
        'lib/screenplay-xml/html/TOW_Fountainhead_1.html',
        "found a file"
    );

    # TEST
    post_dest_test( 'POST_DEST_ZIP_MODS', 'Iglu/shlomif/mods/dreams2.xm.zip',
        "found a file" );

    # TEST
    post_dest_test( 'POST_DEST_XZ_MODS', 'Iglu/shlomif/mods/focus.mod.xz',
        "found a file" );

    # TEST
    post_dest_test( 'POST_DEST_DIRS', "art/original-graphics", "found a dir" );

    # TEST
    post_dest_test( 'SRC_SVGS__svgz', "images/bk2hp-v2.svgz",
        "bk2hp-v2 svg is present." );
}
