#!/usr/bin/env perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon::Obj;

Shlomif::Homepage::Amazon::Obj->new(
    {
        wml_dir      => "src/art/recommendations/music",
        lib_dir      => "lib/prod-synd/music",
        xml_basename => "shlomi-fish-music-recommendations.xml",
    }
)->process;
