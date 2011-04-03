#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon
    {
        wml_dir => "t2/philosophy/books-recommends",
        lib_dir => "lib/prod-synd/non-fiction-books",
        xml_basename => "shlomi-fish-non-fiction-books-recommendations.xml",
    }
    ;
