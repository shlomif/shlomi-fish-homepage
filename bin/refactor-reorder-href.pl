#! /usr/bin/env perl
#
# Short description for reorder-href.pl
#
# Version 0.0.1
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp         qw/ confess /;
use Getopt::Long qw/ GetOptions /;
use Path::Tiny   qw/ cwd path tempdir tempfile /;

sub run
{
    if ( my ( $s, $m, $href, $fin ) =
m&(\[\%\s+WRAPPER\s+h[0-9]+_section\s+)([^\n\r]+)(href = (?:\S+) )([^\n]+)&ms
        )
    {
        $_ = ( $s . $href . $m . $fin );
    }
}

run();

1;

__END__
