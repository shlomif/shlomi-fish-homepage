#! /usr/bin/env perl
#
# Short description for g1.pl
#
# Version 0.0.1
# Copyright (C) 2023 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp                                   qw/ confess /;
use Getopt::Long                           qw/ GetOptions /;
use Path::Tiny                             qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

my $t = qq#[% main_class.addClass("fancy_sects") %]#;
s#^\Q$t\E\n+##gms;
s#(<div class=")([\w\s]+?)(">)#
    my ($s,$m,$e)=($1,$2,$3);
    $s . join(" ",sort split /\s+/,$m) . $e
#egms;

