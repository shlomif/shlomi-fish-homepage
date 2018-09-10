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

    return HTML::Tidy5->new( { input_xml => 1, output_xhtml => 1, } );
}

package main;

my %whitelist = (
    map { $_ => 1 } (
        'post-dest/t2/humour/human-hacking/arabic-v2.html',
'post-dest/t2/humour/human-hacking/arabic-v2/human-hacking-field-guide-v2-arabic/index.html',
'post-dest/t2/lecture/WebMetaLecture/slides/examples/APIs/toc/index.html',
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
