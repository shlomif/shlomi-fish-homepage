#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon::Obj;

Shlomif::Homepage::Amazon::Obj->new(
    {
        wml_dir      => "t2/humour/recommendations/films",
        lib_dir      => "lib/prod-synd/films",
        xml_basename => "shlomi-fish-films-recommendations.xml",
    }
)->process;
