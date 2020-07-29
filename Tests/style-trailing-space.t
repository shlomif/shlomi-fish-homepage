#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::TrailingSpace 0.0400 ();
use lib './lib';

# TEST
Test::TrailingSpace->new(
    {
        find_cr   => 0,
        find_tabs => 0,
        root      => '.',
        filename_regex =>
qr/(?:(?:\.(?:bash|atom|c|cfg|cgi|cmake|conf|cpp|css|desktop|dsl|dtd|ent|ggr|h|hs|htm|ini|m|mak|markdown|md|ml|opml|pod|pov|rb|rc|rng|scm|sh|slides|spec|svg|t|tex|tt|tt2|txt|vim|wml|wmlrc|xsl|xslt|yaml|yml|t|pm|pl|PL|yml|json|(?:x?html)|wml|xml|js|mak))|README|Changes|Makefile)\z/,
        abs_path_prune_re => qr%
            \A(?:
            (?:
            src/(?:lecture/(?:CMake|HTML-Tutorial/v1/xhtml1/hebrew)|(?:js/MathJax.*?\z))
            )
            |
            bower_components
            |
            dest
            |
            lib/js/MathJax
            |
            lib/js/jquery-expander
            |
            lib/presentations/docbook/html-tutorial
            |
            lib/presentations/qp/[\w\-_\.0-9/]*?/rendered
            |
            # We add node_modules due to Travis-CI build failures. Do not
            # remove!
            node_modules
            )
            %msx,
    },
)->no_trailing_space("No trailing space was found.");
