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
        'post-dest/t2/humour/human-hacking/arabic-v2.html',
'post-dest/t2/humour/human-hacking/arabic-v2/human-hacking-field-guide-v2-arabic/index.html',
'post-dest/t2/lecture/WebMetaLecture/slides/examples/APIs/toc/index.html',
'post-dest/t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.html',
        'post-dest/t2/philosophy/SummerNSA/A-SummerNSA-Reading/index.xhtml',
        'post-dest/t2/open-source/projects/Spark/mission/index.xhtml',
        'post-dest/t2/philosophy/case-for-file-swapping/revision-3/index.xhtml',
        'post-dest/t2/philosophy/computers/high-quality-software/index.xhtml',
'post-dest/t2/philosophy/computers/high-quality-software/rev2/index.xhtml',
'post-dest/t2/philosophy/computers/software-management/end-of-it-slavery/index.xhtml',
'post-dest/t2/philosophy/computers/software-management/perfect-workplace/perfect-it-workplace.xhtml',
'post-dest/t2/philosophy/computers/open-source/foss-licences-wars/index.xhtml',
    ),
);

Test::HTML::Tidy::Recursive::Tidy5->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not(
                exists $whitelist{$fn}
                or $fn =~
                m#\A post-dest/t2/ (?: MathVentures | js/jquery-ui/ ) #x,
            );
        },
        targets => ['./post-dest'],
    }
)->run;
