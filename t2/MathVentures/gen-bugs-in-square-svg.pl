#!/usr/bin/perl

use strict;
use warnings;

use SVG;
use Math::Trig;

my $max_depth = 50;
my $proportion = 0.1;

# TODO : Fix the case where $width != $height.
my $width = 300;
my $height = $width;

my $half_width = $width*0.5;
my $half_height = $height*0.5;

# Calculate some constants
my $angle = rad2deg(atan2($proportion, 1-$proportion));
my $size_ratio = sqrt($proportion**2+(1-$proportion)**2);

my $svg = SVG->new(width=>$width, height=>$height,);
foreach my $depth (0 .. ($max_depth-1))
{
    my $tag = $svg->rectangle(
        x => -$half_width, y => -$half_height,
        width => $width, height => $height,
        id => "rect_$depth",
        transform => "translate($half_width,$half_height) rotate(" . ($angle*$depth) .") scale(" . join(",", ($size_ratio**$depth)x2) . ")",
        style =>
        {
            'fill-opacity' => 0,
            stroke => "black",
            'stroke-width' => "1",
        },
    );
}

my $text = $svg->xmlify(-namespace => "svg");
# Workaround for Mozilla.
$text =~ s{<svg:svg}{<svg};
$text =~ s{</svg:svg>}{</svg>};
$text =~ s{(xmlns="([^"]+)")}{$1 xmlns:svg="$2"};
print $text;
