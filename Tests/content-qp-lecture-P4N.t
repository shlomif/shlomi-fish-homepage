#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More tests => 2;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $SRC_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content =
        path(
"$SRC_POST_DEST/lecture/Perl/Newbies/lecture2/useful_funcs/sort/cmp.html"
    )->slurp_utf8;

    my $needle = <<'EOF';
<span class="Statement">my</span> <span class="Identifier">@array</span> = (<span class="Constant">100</span>,<span class="Constant">5</span>,<span class="Constant">8</span>,<span class="Constant">92</span>,-<span
EOF

    chomp $needle;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct <pre> text' );
}

{
    my $content =
        path("$SRC_POST_DEST/lecture/Perl/Newbies/lecture2/style.css")
        ->slurp_utf8;

    my $needle = 'color:';

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct CSS directive' );
}
