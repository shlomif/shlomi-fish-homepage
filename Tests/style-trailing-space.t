#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::TrailingSpace 0.0201;

{

    my $finder = Test::TrailingSpace->new(
        {
            root => '.',
            filename_regex => qr/(?:(?:\.(?:t|pm|pl|PL|yml|json|(?:x?html)|wml|xml|js))|README|Changes)\z/,
            abs_path_prune_re => qr#
            \A(?:
            (?:
            (?:dest/t2|t2)/(?:lecture/(?:CMake|HTML-Tutorial/v1/xhtml1/hebrew)|(?:js/MathJax.*?\z))
            )
            |
            lib/MathJax
            |
            lib/presentations/docbook/html-tutorial
            |
            (?:
            \Qlib/screenplay-xml/from-vcs/Selina-Mandrake/selina-mandrake/screenplay/selina-mandrake-the-slayer.screenplay-text.xhtml\E\z
            )
            (?:
            |
            \Qlib/screenplay-xml/from-vcs/Selina-Mandrake/selina-mandrake/screenplay/selina-mandrake-the-slayer.final.html\E\z
            )
            )
            #msx,
        },
    );

# TEST
    $finder->no_trailing_space(
        "No trailing space was found."
    );
}
