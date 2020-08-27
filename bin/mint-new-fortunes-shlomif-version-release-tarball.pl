#! /usr/bin/env perl
#
# Short description for mint-new-fortunes-shlomif-version-release-tarball.pl
#
# Version 0.0.1
# Copyright (C) 2020 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the Apache License 2.0.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

use vars qw/ $DIR /;

BEGIN
{
    $DIR = "./src/humour/fortunes";
}
use lib "$DIR";
use ShlomifFortunesMake ();
use lib './lib';
use Shlomif::MySystem qw/ my_system my_exec_perl /;
my_system( [ 'gmake', "-C", $DIR, "dist" ] );
my $package_base = ShlomifFortunesMake->package_base();
my $full_path    = sprintf( "%s/%s", $DIR, $package_base );
my_system( [ "ls", $full_path ] );
