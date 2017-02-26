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
        'dest/t2/js/jquery-ui/index.html',
'dest/t2/open-source/resources/how-to-contribute-to-my-projects/HACKING.html',
        'dest/vipe/js/jquery-ui/index.html',
    ),
);

MyTidy->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not( exists $whitelist{$fn}
                or $fn =~
m#\Adest/t2/(?:MathVentures/|js/MathJax/|open-source/projects/Spark/mission/)#
            );
        },
        targets => [
            './dest/t2/DeCSS/',                 './dest/t2/SFresume.html',
            './dest/t2/SFresume_detailed.html', './dest/t2/art/',
            './dest/t2/index.html',             './dest/t2/grad-fu/',
            './dest/t2/guide2ee/',              './dest/t2/haskell/',
            './dest/t2/homesteading/',          './dest/t2/i-bex/',
            './dest/t2/images/',                './dest/t2/jmikmod/',
            './dest/t2/js/',                    './dest/t2/lambda-calculus/',
            './dest/t2/linux_banner/',          './dest/t2/MathVentures/',
            './dest/t2/me/',                    './dest/t2/meta/',
            './dest/t2/no-ie/',                 './dest/t2/old-news.html',
            './dest/t2/open-source/',           './dest/t2/personal-heb.html',
            './dest/t2/personal.html',          './dest/t2/prog-evolution/',
            './dest/t2/puzzles/',               './dest/t2/recommendations/',
            './dest/t2/rindolf/',               './dest/t2/rwlock/',
            './dest/t2/site-map/',              './dest/t2/work/',
            './dest/vipe/',
        ],
    }
)->run;
