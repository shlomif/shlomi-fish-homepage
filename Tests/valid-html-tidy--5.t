#!/usr/bin/perl

use strict;
use warnings;

package Test::HTML::Tidy::Recursive::Tidy5;

use MooX qw/ late /;
use HTML::Tidy5;

extends('Test::HTML::Tidy::Recursive');

sub calc_tidy
{
    my $self = shift;

    return HTML::Tidy5->new( { output_xhtml => 1, } );
}

package main;

my %whitelist = (
    map { $_ => 1 } (
        'dest/t2/humour/Blue-Rabbit-Log/ideas.xhtml',
        'dest/t2/humour/human-hacking/arabic-v2.html',
'dest/t2/humour/human-hacking/arabic-v2/human-hacking-field-guide-v2-arabic/index.html',
        'dest/t2/humour/humanity/songs/index.html',
        'dest/t2/lecture/WebMetaLecture/slides/examples/APIs/toc/index.html',
'dest/t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.html',
'dest/t2/philosophy/case-for-file-swapping/revision-3/case-for-file-swapping-rev3/internet_as_alternative_medium.html',
        'dest/t2/philosophy/case-for-file-swapping/revision-3/index.html',
'dest/t2/philosophy/computers/web/create-a-great-personal-homesite/rev2.html',
    ),
);

Test::HTML::Tidy::Recursive::Tidy5->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not(
                exists $whitelist{$fn}
                or $fn =~ m#\A dest/t2/ (?: MathVentures | js/jquery-ui/ ) #x,
            );
        },
        targets => ['./dest'],
    }
)->run;
