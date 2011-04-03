#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon;

my $wml_dir = "t2/art/recommendations/music";
my $lib_dir = "lib/prod-synd/music";
my $xml_basename = "shlomi-fish-music-recommendations.xml";

my $amazon = 
    Shlomif::Homepage::Amazon->new(
    {
        lib_dir => $lib_dir,
        xml_basename => $xml_basename,
        wml_dir => $wml_dir,
    });

$amazon->process;
