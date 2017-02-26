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
            return not exists $whitelist{ shift @_ };
        },
        targets => [
            './dest/t2/me/',                    './dest/t2/meta/',
            './dest/t2/open-source/resources/', './dest/t2/work/',
            './dest/vipe/',
        ],
    }
)->run;
