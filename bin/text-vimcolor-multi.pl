#! /usr/bin/env perl
#
# Short description for text-vimcolor-xhtml5.pl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
# Copyright (C) 2019 Shlomi Fish <shlomif@cpan.org>
#
use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

use Text::VimColor ();

my ( $in_dir, $out_dir ) = @ARGV;
my $out = path($out_dir);
foreach my $in ( path($in_dir)->children(qr/\.scm\z/) )
{
    my $syntax = Text::VimColor->new(
        file           => "$in",
        xhtml5         => 1,
        html_title     => '[untitled]',
        html_full_page => 1
    );
    open my $o, ">:encoding(utf8)", $out->child( $in->basename() . ".html" );
    print {$o} $syntax->html();
    close $o;
}
