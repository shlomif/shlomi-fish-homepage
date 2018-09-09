#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 1;
use Path::Tiny qw/ path /;

{
    my $content = path(
"lib/cache/combined/t2/lecture/W2L/Network/index.xhtml/breadcrumbs-trail"
    )->slurp_utf8;

    # TEST
    is( $content, <<'EOF', 'right one' );
<a href="../../../">Shlomi Fish’s Homepage</a> → <a href="../../" title="Presentations I Wrote (Mostly Technical)">Lectures</a> → <a href="../" title="Presentations in the Series for Linux Beginners">Welcome to Linux</a> → <a href="./" title="Networking in Linux Explanation and Howto">Networking</a>
EOF
}
