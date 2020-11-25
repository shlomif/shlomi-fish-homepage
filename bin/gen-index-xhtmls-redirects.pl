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
    # next if $fn !~ /XSLT/;
    my $dn = path($fn)->dirname;
    push @dirs, ( ( $dn eq "." ) ? "" : ( $dn =~ s#[/\\]\z##r ) );
}

my $out_text = '';
foreach my $dn (@dirs)
{
    if ( length $dn )
    {
        $dn .= "/";
    }
    $out_text .= qq#Redirect permanent /${dn}index.html /${dn}\n#;
}
print $out_text;

if (0)
{
    print
qq#RewriteRule "^(/(?:@{[join("|", @dirs)]})/)index\\.html\$" "\$1" [R]\n#;
}
