#! /usr/bin/env perl
#
# Short description for reindent-pandoc-gh-flavored-markdown-output-to-4-spaces.pl
#
# Version 0.0.1
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;
use integer;

use Carp qw/ confess /;

sub _replace
{
    my ( $space, $suffix, ) = @_;
    my $len = length($space) / 2;
    return ( ( " " x ( $len * 4 ) ) . $suffix );
}

s&^((?:  )+)(\-)& _replace($1, $2, ) &ems;

__END__
