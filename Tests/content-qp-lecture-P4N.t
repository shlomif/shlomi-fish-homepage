#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 1;
use Path::Tiny qw/ path /;

{
    my $content =
        path(
"./post-dest/t2/lecture/Perl/Newbies/lecture2/useful_funcs/sort/cmp.html"
    )->slurp_utf8;

    my $needle = <<'EOF';
<span class="Statement">my</span> <span class="Identifier">@array</span> = (<span class="Constant">100</span>,<span class="Constant">5</span>,<span class="Constant">8</span>,<span class="Constant">92</span>,-<span
EOF

    chomp $needle;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct <pre> text' );
}
