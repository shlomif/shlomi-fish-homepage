#!/usr/bin/env perl

# Generate an SVG diagram as a model for:
# -- http://www.shlomifish.org/MathVentures/bugs-in-square-mathml.xhtml

use strict;
use warnings;

use SVG        ();
use Math::Trig qw/ rad2deg /;

my $max_depth  = 50;
my $proportion = 0.1;

# TODO : Fix the case where $width != $height.
my $width  = 300;
my $height = $width;

my $half_width  = $width * 0.5;
my $half_height = $height * 0.5;

# Calculate some constants
my $angle      = rad2deg( atan2( $proportion, 1 - $proportion ) );
my $size_ratio = sqrt( $proportion**2 + ( 1 - $proportion )**2 );

my $svg   = SVG->new( width => $width, height => $height, );
my $FIELD = "%f";

my $TRANSFORM_FORMAT = "translate(%%,%%) rotate(%%) scale(%%,%%)";
$TRANSFORM_FORMAT =~ s/\%\%/${FIELD}/g;
foreach my $depth ( 0 .. ( $max_depth - 1 ) )
{
    my $transform = sprintf( $TRANSFORM_FORMAT,
        $half_width, $half_height,
        ( $angle * $depth ),
        ( ( $size_ratio**$depth ) x 2 ),
    );

    my $tag = $svg->rectangle(
        x         => -$half_width,
        y         => -$half_height,
        width     => $width,
        height    => $height,
        id        => "rect_$depth",
        transform => $transform,
        style     => {
            'fill-opacity' => 0,
            stroke         => "black",
            'stroke-width' => "1",
        },
    );
}

my $text = $svg->xmlify( -namespace => "svg" );

# Workaround for Mozilla.
$text =~ s{<svg:svg}{<svg};
$text =~ s{</svg:svg>}{</svg>};
$text =~ s{(xmlns="([^"]+)")}{$1 xmlns:svg="$2"};
print $text;

=head1 COPYRIGHT & LICENSE

Copyright 2012 by Shlomi Fish

This program is distributed under the MIT (Expat) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
