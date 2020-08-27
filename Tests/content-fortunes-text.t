#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 9;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths::Test ();

my $obj       = HTML::Latemp::Local::Paths::Test->new();
my $POST_DEST = $obj->t2_post_dest();

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

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
