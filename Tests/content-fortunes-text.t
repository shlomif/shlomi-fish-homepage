#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 3;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths;

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content = path("$T2_POST_DEST/humour/fortunes/shlomif")->slurp_utf8;

    # TEST
    like(
        $content,
        qr{You are banished! You}ms,
        'Plain text fortune exists and contains text.',
    );

    # TEST
    ok( scalar( -e "$T2_POST_DEST/humour/fortunes/tinic.dat" ),
        ".dat file exists." );

    # TEST
    cmp_ok(
        scalar(
            -s "$T2_POST_DEST/humour/fortunes/fortunes-shlomif-lookup.sqlite3"
        ),
        ">", 1024,
        "sqlite database is there"
    );
}

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
