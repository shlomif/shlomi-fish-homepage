#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 1;
use Path::Tiny qw/ path /;
use lib './lib';
use Shlomif::Homepage::Paths ();

my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

{
    my $content =
        path(
        "$T2_POST_DEST/lecture/Perl/Newbies/lecture2/useful_funcs/sort/cmp.html"
    )->slurp_utf8;

    my $needle = <<'EOF';
<span class="Statement">my</span> <span class="Identifier">@array</span> = (<span class="Constant">100</span>,<span class="Constant">5</span>,<span class="Constant">8</span>,<span class="Constant">92</span>,-<span
EOF

    chomp $needle;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct <pre> text' );
}
