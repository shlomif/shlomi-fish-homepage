#!/usr/bin/perl

use strict;
use warnings;
use Path::Tiny qw/ path /;

use File::Find;

find( \&wanted, "./src" );

sub process
{
    my $text = shift;
    $text =~ s!^<h3 class="notbold">(.*<ul>)!!s;
    $text =~ s!(</ul>.*)?</h3>!!s;
    $text =~ s!<li\s+class="notbold">!<li>!g;
    return "<points>\n$text</points>";
}

sub wanted
{
    my $filename = $_;
    if ( $filename =~ /\.html\.wml$/ )
    {
        my $text = path($filename)->slurp_utf8;
        $text =~ s!(<h3 class="notbold">.*?</h3>)!&process($1)!sge;

        print "$File::Find::name\n\n\n";

        print $text;

        path($filename)->spew_utf8($text);
    }
}

