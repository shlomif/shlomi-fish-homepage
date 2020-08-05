#! /usr/bin/env perl
#
# Short description for normalize-zip.pl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
# Based on strip-nondeterminism. GPLed.
#
use strict;
use warnings;

use File::StripNondeterminism::handlers::zip ();

File::StripNondeterminism::init();

$File::StripNondeterminism::canonical_time =
    $File::StripNondeterminism::clamp_time = 0;
for my $fn (@ARGV) { File::StripNondeterminism::handlers::zip::normalize($fn) }
