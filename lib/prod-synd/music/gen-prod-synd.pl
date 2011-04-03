#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon
    {
        wml_dir => "t2/art/recommendations/music",
        lib_dir => "lib/prod-synd/music",
        xml_basename => "shlomi-fish-music-recommendations.xml",
    }
    ;
