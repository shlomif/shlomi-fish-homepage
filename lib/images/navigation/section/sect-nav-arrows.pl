#!/usr/bin/env perl

use strict;
use warnings;

use SVG;
use Path::Tiny qw/ path /;

my $dim    = 30;
my $width  = $dim;
my $height = $dim;

my $dest_dir = shift(@ARGV);

foreach my $button_style (
    {
        basename => '',
        style    => {
            stroke => 'black',
            fill   => 'black',
        },
    },
    {
        basename => '-disabled',
        style    => {
            stroke => '#808080',
            fill   => '#909090',
        },
    },
    {
        basename => '-pressed',
        style    => {
            'stroke-width' => '2pt',
            stroke         => 'red',
            fill           => 'orange',
        },
    },
    )
{
    my $button_basename = $button_style->{basename};

    foreach my $rotation (
        {
            basename => 'left',
        },
        {
            basename => 'up',
            rot      => 90,
        },
        {
            basename => 'right',
            rot      => 180,
        }
        )
    {
        my $basename = $rotation->{basename};

        my $half_width   = $width / 2;
        my $half_height  = $height / 2;
        my $halves       = "$half_width,$half_height";
        my $minus_halves = "-$half_width,-$half_height";
        my $svg          = SVG->new( width => $width, height => $height );
        my $group1       = $svg->group(
            id        => 'group1',
            style     => { stroke => 'black', fill => 'black', },
            transform => sprintf(
                "%s %s",
                "translate($halves) scale(0.8) translate($minus_halves)",
                (
                    exists( $rotation->{rot} )
                    ? "rotate($rotation->{rot},$halves)"
                    : ''
                ),
            ),
        );

        my $xs = [ 0, $width, $width ];
        my $ys = [ $height / 2, 0, $height ];
        foreach my $ref ( $xs, $ys )
        {
            push @$ref, $ref->[0];
        }
        my $points = $group1->get_path(
            x       => $xs,
            y       => $ys,
            -type   => 'polyline',
            -closed => 'true',
        );

        my $tag = $group1->polyline(
            %$points,
            id    => 'arrow1',
            style => {
                'stroke-linejoin' => 'round',
                %{ $button_style->{style} },
            },
        );
        path("$dest_dir/sect-arr-$basename$button_basename.svg")
            ->spew(
            scalar( $svg->xmlify() ) =~ s/<!--.*?-->//gmrs =~ s/[ \t]+$//gmrs );
    }
}
