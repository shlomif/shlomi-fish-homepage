#! /usr/bin/env perl
#
# Short description for multi-gm.pl
#
# Version 0.0.1
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Graphics::Magick ();

my $src  = shift;
my $dest = shift;
foreach my $fn (@ARGV)
{
    my $im = Graphics::Magick->new;
    $im->Read($fn);
    $im->Write( $fn =~ s#\Q$src\E\z#$dest#r );
}
