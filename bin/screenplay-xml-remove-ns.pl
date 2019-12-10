#! /usr/bin/env perl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
# Copyright (C) 2019 Shlomi Fish <shlomif@cpan.org>
#
use strict;
use warnings;
use 5.014;
use autodie;
if (m#^<html #ms)
{
s#\Q xmlns:sp="http://web-cpan.berlios.de/modules/XML-Grammar-Screenplay/screenplay-xml-0.2/"\E##;
    my $d = $ENV{DIR};
    $d and s/(<html )/$1dir="$d" /;
}
