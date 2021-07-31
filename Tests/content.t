#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 29;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths::Test ();

my $obj       = HTML::Latemp::Local::Paths::Test->new();
my $POST_DEST = $obj->t2_post_dest();

{
    my $content = path("$POST_DEST/images/bk2hp-v2.min.svg")->slurp_utf8;

    # TEST
    like( $content, qr{<svg}, 'Contains a tag.' );

    # TEST
    ok( scalar( -e "$POST_DEST/images/bk2hp.png" ), "bk2hp.png" );
}

{
    my $content =
        path(
"$POST_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/index.xhtml"
    )->slurp_utf8;

    # TEST
    ok(
        scalar(
            index( $content,
q{<a href="#machines_that_can_give_questions">The Machines That Can Give You Questions</a>}
            ) >= 0
        ),
        'Contains a hyperlink.'
    );
}

{
    my $content =
        path("$POST_DEST/prog-evolution/shlomif-at-cortext.html")->slurp_utf8;

    # TEST
    ok(
        scalar(
            index( $content,
q{<a href="#how_i_started">How I started Working for Cortext</a>}
                ) >= 0
                and index(
                $content,
                q{<h2 id="how_i_started">How I started Working for Cortext</h2>}
                ) >= 0
        ),
        'Contains a hyperlink.'
    );
}

{
    my $content =
        path(
"$POST_DEST/philosophy/politics/drug-legalisation/case-for-drug-legalisation/style.css"
    )->slurp_raw;

    # TEST
    ok( scalar( index( $content, q{palegreen} ) >= 0 ), 'Contains CSS', );
}

{
    my $content =
        path("$POST_DEST/humour/fortunes/sharp-programming.html")->slurp_utf8;

    # TEST
    like(
        $content,
qr{<a href=\r?\n?"https://en.wikipedia.org/wiki/NP-completeness" rel=\r?\n?"nofollow">https://en.wikipedia.org/wiki/NP-completeness</a>},
        'Contains a hyperlink.'
    );
}

{
    my $fh = path("$POST_DEST/humour/fortunes/show.cgi");

    # TEST
    ok( -x $fh, "show.cgi is executable." );

    # TEST
    like( $fh->slurp_utf8, qr%\A#!.{50}%ms, "shebang is present" );
}

{
    # TEST
    $obj->_fortunes_check_size("fortunes-shlomif-all.atom");

    # TEST
    $obj->_fortunes_check_size("fortunes-shlomif-all.rss");

    # TEST
    ok( scalar( !-e "$POST_DEST/humour/fortunes/fortunes-shlomif.spec" ),
        "existence of .spec file" );

    # TEST
    $obj->_fortunes_check_size("fortunes_show.py");

    # TEST
    $obj->_fortunes_check_size("fortunes-shlomif.epub");
}

{
    my $content = path("$POST_DEST/humour/fortunes/shlomif")->slurp_utf8;

    # TEST
    like(
        $content,
        qr{You are banished! You}ms,
        'Plain text fortune exists and contains text.',
    );

    $content = path("$POST_DEST/humour/fortunes/shlomif-factoids")->slurp_utf8;

    # TEST
    unlike(
        $content,
qr{https?\Q://www.shlomifish.org/humour/bits/facts/\EChuck[^\-]Norris/}ms,
        'Search for "Chuck-Norris"',
    );

    # TEST
    unlike(
        $content,
        qr{https?\Q://www.shlomifish.org/humour/bits/facts/\EXena[^/]}ms,
        'Search for "Xena" URLs',
    );

    #
    # TEST
    like( $content, qr{Xena can meet King David}ms, 'Search for "Xena"', );
    #
    # TEST
    like(
        $content,
        qr{Xena the Warrior Princess has not met Chuck}ms,
        'Search for "Xena"',
    );

    # TEST
    ok( scalar( -e "$POST_DEST/humour/fortunes/tinic.dat" ),
        ".dat file exists." );

    # TEST
    $obj->_fortunes_check_size("fortunes-shlomif-lookup.sqlite3");

    # TEST
    ok(
        scalar(
            -f "$POST_DEST/humour/human-hacking/human-hacking-field-guide-hebrew-v2.db-postproc.xslt"
        ),
        "hhfg xslt exists",
    );

    # TEST
    ok(
        scalar(
            -f "$POST_DEST/humour/human-hacking/human-hacking-field-guide-hebrew-v2.txt"
        ),
        "hhfg hebrew txt exists",
    );

    # TEST
    ok(
        scalar(
            (
                -s "$POST_DEST/humour/human-hacking/human-hacking-field-guide/background-image.png"
            ) > 40
        ),
        "hhfg png exists",
    );

    # TEST
    ok(
        scalar(
            (
                -s "$POST_DEST/humour/human-hacking/human-hacking-field-guide-v2/docbook.css"
            ) > 20
        ),
        "hhfg-v2 docbook.css exists",
    );
}

{
    # TEST
    $obj->_check_size("js/main_all.js");

    # TEST
    $obj->_check_size("js/jquery.expander.min.js");

    # TEST
    $obj->_check_size(
        "humour/Terminator/Liberation/images/emma-watson-wandless.svg.webp");

    # TEST
    $obj->_check_size(
        "humour/Summerschool-at-the-NSA/images/xkcd-725-literally.png");

    # TEST
    $obj->_check_size("humour/Muppets-Show-TNI/images/xkcd-406-venting.png");
}

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
