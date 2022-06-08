#!/usr/bin/env perl

use strict;
use warnings;
use Carp::Always;

use Shlomif::Homepage::Amazon::Obj ();

Shlomif::Homepage::Amazon::Obj->new(
    {
        src_dir      => "src/humour/recommendations/films",
        lib_dir      => "lib/prod-synd/films",
        xml_basename => "shlomi-fish-films-recommendations.xml",
    }
)->process;
