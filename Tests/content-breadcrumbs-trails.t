#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More tests => 2;
use Path::Tiny qw/ path /;

sub _test
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($args) = @_;
    my ( $path, $expected, $blurb ) = @$args{qw(path expected blurb)};

    my $content = path($path)->slurp_utf8;

    return is( $content . "\n",
        $expected, "$path breadcrumbs trail content is right - $blurb" );
}

# TEST
_test(
    {
        path =>
"lib/cache/combined/t2/lecture/W2L/Network/index.xhtml/breadcrumbs-trail",
        blurb    => 'w2l-networking-lecture',
        expected => <<'EOF',
<a href="../../../">Shlomi Fish’s Homepage</a> → <a href="../../" title="Presentations I Wrote (Mostly Technical)">Lectures</a> → <a href="../" title="Presentations in the Series for Linux Beginners">Welcome to Linux</a> → <a href="./" title="Networking in Linux Explanation and Howto">Networking</a>
EOF
    }
);

# TEST
_test(
    {
        path =>
"lib/cache/combined/t2/humour/bits/facts/Buffy/index.xhtml/breadcrumbs-trail",
        blurb    => 'buffy factoids',
        expected => <<'EOF',
<a href="../../../../">Shlomi Fish’s Homepage</a> → <a href="../../../" title="My Humorous Creations">Humour</a> → <a href="../../../aphorisms/">Aphorisms and Quotes</a> → <a href="../" title="“Facts” about Chuck Norris and other things">Factoids</a> → <a href="./">Buffy Facts</a>
EOF
    }
);
