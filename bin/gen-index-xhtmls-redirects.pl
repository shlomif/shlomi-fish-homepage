#! /usr/bin/env perl
#
# Short description for gen-index-xhtmls-redirects.pl
#
# Version 0.0.1
# Copyright (C) 2020 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Data::Munge qw/ list2re /;
use Path::Tiny qw/ path tempdir tempfile cwd /;
use File::Find::Object::Rule ();

my $dir_src = 'dest/post-incs/t2';
my $IDX     = 'index.xhtml';
my @filenames =
    File::Find::Object::Rule->name($IDX)->relative()->in( $dir_src, );
my @dirs;
foreach my $fn (@filenames)
{
    my $dn = path($fn)->dirname;
    push @dirs, quotemeta( ( $dn eq "." ) ? "" : ( $dn =~ s#[/\\]\z##r ) );
}

print
    qq#RewriteRule "^(/(?:@{[join("|", @dirs)]})/)index\\.html\$" "\$1" [R]\n#;
