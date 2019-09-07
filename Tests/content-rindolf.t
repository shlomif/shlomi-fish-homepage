#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

{
    my $content =
        path("$T2_POST_DEST/rindolf/intro_to_rindolf.html")->slurp_utf8;

    # TEST
    like( $content, qr{ \# Prints myfunc\(}, 'Contains a comment.' );
}

{
    my $content = path("$T2_POST_DEST/me/rindolf/index.xhtml")->slurp_utf8;

    # TEST
    like( $content, qr{\[no-"the"!\]}, 'Contains the string' );
}

{
    my $content =
        path(
"$T2_POST_DEST/humour/bits/Emma-Watson-applying-for-a-software-dev-job/index.xhtml"
    )->slurp_utf8;

    my $needle =
q#<a href="https://en.wikipedia.org/wiki/Harry_Potter_%28film_series%29">#;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct URL.' );

}

{
    my $content =
        path("$T2_POST_DEST/humour/bits/Spam-for-Everyone/index.xhtml")
        ->slurp_utf8;

    my $needle = q#<h2 id="license">#;

    # TEST
    like( $content, qr{\Q$needle\E}, 'Contains the correct URL.' );
}
