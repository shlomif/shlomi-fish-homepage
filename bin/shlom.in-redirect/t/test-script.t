#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;

{
    # TEST
    is(
        scalar(`REDIRECT_URL=/graphics $^X shlom.in-refer.pl`),
qq#Status: 301\r\nLocation: https://www.shlomifish.org/open-source/resources/graphics-programs/\r\n\r\n#,
        "graphics link.",
    );

    my $url =
        "https://www.shlomifish.org/open-source/resources/graphics-programs/";
    my $html = scalar(`REDIRECT_URL=/ $^X shlom.in-refer.pl`);

    # TEST
    like( $html,
        qr#<td class="full"><p><a href="\Q$url\E">\Q$url\E</a></p></td>#ms,
        "full url", );
}
