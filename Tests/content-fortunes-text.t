#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 5;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths;

my $SRC_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content = path("$SRC_POST_DEST/humour/fortunes/shlomif")->slurp_utf8;

    # TEST
    like(
        $content,
        qr{You are banished! You}ms,
        'Plain text fortune exists and contains text.',
    );

    # TEST
    ok( scalar( -e "$SRC_POST_DEST/humour/fortunes/tinic.dat" ),
        ".dat file exists." );

    # TEST
    cmp_ok(
        scalar(
            -s "$SRC_POST_DEST/humour/fortunes/fortunes-shlomif-lookup.sqlite3"
        ),
        ">", 1024,
        "sqlite database is there"
    );

    # TEST
    ok(
        scalar(
            -f "$SRC_POST_DEST/humour/human-hacking/human-hacking-field-guide-hebrew-v2.db-postproc.xslt"
        ),
        "hhfg xslt exists",
    );

    # TEST
    ok(
        scalar(
            -f "$SRC_POST_DEST/humour/human-hacking/human-hacking-field-guide-hebrew-v2.txt"
        ),
        "hhfg hebrew txt exists",
    );
}

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
