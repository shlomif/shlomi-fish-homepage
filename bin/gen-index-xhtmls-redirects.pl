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

use Data::Munge              qw/ list2re /;
use List::Util               qw/ none /;
use Path::Tiny               qw/ path tempdir tempfile cwd /;
use File::Find::Object::Rule ();

my $dir_src = 'dest/post-incs/t2';
my $IDXH    = 'index.html';
my $IDX     = 'index.xhtml';
my @filenames =
    File::Find::Object::Rule->name($IDX)->relative()->in( $dir_src, );
my @dirs;
my $out_text = '';
foreach my $fn (@filenames)
{
    # next if $fn !~ /XSLT/;
    my $dn = path($fn)->parent;
    die if -e $dn->child($IDXH);
    if ( $dn ne "." )
    {
        my $dslash   = "$dn/";
        my $new_text = qq#Redirect permanent /${dslash}${IDXH} /${dslash}\n#;
        my $fh =
            path($dir_src)->child( ( split m#/#, $dn ), ".htaccess" );
        if ( ( !-e $fh ) or ( none { $_ eq $new_text } $fh->lines_utf8() ) )
        {
            $fh->append_utf8($new_text);
        }
    }

    #push @dirs, ( ( $dn eq "." ) ? "" : ( $dn =~ s#[/\\]\z##r ) );
}

if (0)
{
    foreach my $dn (@dirs)
    {
        my $is_subdir = length $dn;
        if ($is_subdir)
        {
            $dn .= "/";
        }
        my $new_text = qq#Redirect permanent /${dn}${IDXH} /${dn}\n#;
        if ($is_subdir)
        {
            path($dir_src)->child( ( split m#/#, $dn ), ".htaccess" )
                ->append_utf8($new_text);
        }
        $out_text .= $new_text;
    }
    print $out_text;

    print
qq#RewriteRule "^(/(?:@{[join("|", @dirs)]})/)index\\.html\$" "\$1" [R]\n#;
}
