#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 15;
use lib './lib';
use HTML::Latemp::Local::Paths ();

use Path::Tiny qw/ path cwd /;

my $PRE_DEST  = HTML::Latemp::Local::Paths->new->t2_pre_dest;
my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

delete $ENV{MAKEFLAGS};

my %cache;

sub re_test
{
    my ( $var, $re, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return like( scalar( $cache{$var} //= `gmake $var.show` ), $re, $blurb, );
}

sub gmake_test
{
    my ( $var, $word, $blurb ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return re_test( $var, qr%(?:\A| )\Q$word\E(?:\n|\z| )%ms, $blurb, );
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
    re_test( 'RSYNC_EXCLUDES', qr#--exclude.*?js/MathJax#ms, "RSYNC_EXCLUDES" );

    # TEST
    gmake_test( 'DOCBOOK5_EPUB_DIR', 'lib/docbook/5/epub',
        "DOCBOOK5_EPUB_DIR" );

    foreach my $word (
        qw#
        Friends-S02E04--Nothing-Sexier.svg.jpg
        If-You-Wanna-Be-Sad.svg.jpg
        Standup-Philosopher.svg.webp
        sigourney-weaver--resized.jpg
        summer-glau--two-guns--400w.jpg
        #
        )
    {
        # TEST*5
        gmake_test(
            'SO_WHO_THE_HELL_IS_QOHELETH_SCREENPLAY_IMAGES__BASE',
            $word,
            "SO_WHO_THE_HELL_IS_QOHELETH_SCREENPLAY_IMAGES__BASE - word=$word"
        );
    }

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
    gmake_test(
        'FICTION_DB5S',
        "lib/docbook/5/xml/The-Pope-Died-on-Sunday-english.xml",
        "found a fiction docbook"
    );

    # TEST
    post_dest_test( 'POST_DEST_DIRS', "art/original-graphics", "found a dir" );

    # TEST
    post_dest_test( 'SRC_SVGS__svgz', "images/bk2hp-v2.svgz",
        "bk2hp-v2 svg is present." );
}

{
    # TEST
    unlike(
        path("lib/make/rules.mak")->slurp_raw(),
        qr/ttml/i, "No rules for unused ttml/TTML",
    );
}
