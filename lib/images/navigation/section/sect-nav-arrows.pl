#!/usr/bin/perl

use strict;
use warnings;

use SVG;
use IO::All;

my $width = 100;
my $height = 100;


foreach my $rotation (
    {
        basename => 'l',
    },
    {
        basename => 'u',
        rot => 90,
    },
    {
        basename => 'r',
        rot => 180,
    }
)
{
    my $basename = $rotation->{basename};

    my $svg = SVG->new(width => $width, height => $height);
    my $group1 = $svg->group(
        id=>'group1',
        style => {stroke => 'black', fill => 'black',},
        exists($rotation->{rot}) ? (transform => "rotate($rotation->{rot} @{[$width/2]} @{[$height/2]})") : (),
    );

    my $points = $group1->get_path(
        x => [0, $width, $width],
        y => [$height/2, 0, $height],
        -type => 'polyline',
        -closed => 'true',
    );

    my $tag = $group1->polyline(
        %$points,
        id => 'arrow1',
        style => {
            stroke => 'black',
            fill => 'black',
        },
    );
    io->file("./common/images/sect-arr-$basename.svg")->print($svg->xmlify());
}

