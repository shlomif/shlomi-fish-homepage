#!/usr/bin/perl

use strict;
use warnings;

package MyTidy;

use MooX qw/ late /;

extends('Test::HTML::Tidy::Recursive');

sub calc_tidy
{
    my $self = shift;

    my $tidy = HTML::Tidy->new( { output_xhtml => 1, } );

    # $tidy->ignore( type => TIDY_WARNING, type => TIDY_INFO );

    return $tidy;
}

package main;

my %whitelist = (
    map { $_ => 1 } (
'dest/t2/open-source/resources/how-to-contribute-to-my-projects/HACKING.html',
        'dest/vipe/js/jquery-ui/index.html',
    ),
);

MyTidy->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not( exists $whitelist{$fn}
                or $fn =~ m#\Adest/t2/open-source/projects/Spark/mission# );
        },
        targets => [
            './dest/t2/SFresume.html',
            './dest/t2/SFresume_detailed.html',
            './dest/t2/art/',
            './dest/t2/index.html',
            './dest/t2/me/',
            './dest/t2/meta/',
            './dest/t2/old-news.html',
            './dest/t2/open-source/anti/',
            './dest/t2/open-source/bits-and-bobs/',
            './dest/t2/open-source/bits.html',
            './dest/t2/open-source/by-others/',
            './dest/t2/open-source/contributions/',
            './dest/t2/open-source/favourite/',
            './dest/t2/open-source/projects/',
            './dest/t2/open-source/resources/',
            './dest/t2/personal-heb.html',
            './dest/t2/personal.html',
            './dest/t2/prog-evolution/',
            './dest/t2/puzzles/',
            './dest/t2/work/',
            './dest/vipe/',
        ],
    }
)->run;
