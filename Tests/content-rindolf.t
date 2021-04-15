#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More tests => 6;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content = path("$POST_DEST/rindolf/intro_to_rindolf.html")->slurp_utf8;

    # TEST
    like( $content, qr{ \# Prints myfunc\(}, 'Contains a comment.' );
}

{
    my $content = path("$POST_DEST/me/rindolf/index.xhtml")->slurp_utf8;

    # TEST
    like( $content, qr{\[no-"the"!\]}, 'Contains the string' );
}

{
    my $content =
        path(
"$POST_DEST/humour/bits/Emma-Watson-applying-for-a-software-dev-job/index.xhtml"
    )->slurp_utf8;

    my $needle =
q#<a href="https://en.wikipedia.org/wiki/Harry_Potter_%28film_series%29">#;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct URL.' );

}

{
    my $content =
        path("$POST_DEST/humour/bits/Spam-for-Everyone/index.xhtml")
        ->slurp_utf8;

    my $needle = q#<h2 id="license">#;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct URL.' );
}
{
    foreach my $path (
        path(
"$POST_DEST/philosophy/culture/case-for-commercial-fan-fiction/index.xhtml"
        ),
        path(
"$POST_DEST/philosophy/culture/case-for-commercial-fan-fiction/indiv-nodes/context.xhtml"
        ),

        )
    {
        my $content = $path->slurp_utf8;

        my $needle = q#Queen Padmé#;

        # TEST*2
        like( $content, qr{\Q$needle\E}, "$path contains the Padme needle", );
    }
}
