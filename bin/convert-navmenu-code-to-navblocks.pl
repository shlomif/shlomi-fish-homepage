#! /usr/bin/env perl
#
# Short description for trans.pl
#
# Version 0.0.1
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

s/\{/_l(/g;
s/\}/)/g;
s/^ *url / path /gms;
s/^ *text / inner_html /gms;
