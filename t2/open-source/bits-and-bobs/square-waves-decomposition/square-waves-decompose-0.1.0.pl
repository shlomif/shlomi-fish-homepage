#!/usr/bin/perl
#
# square-waves-decompose.pl : compose a sine wave out of square waves.
#
# The results of this program can be plotted using the gnuplot command:
#
#     plot "gnuplot.dat" , "sinplot.dat"
#
# Written by Shlomi Fish, 2008.
#
# Licensed under the MIT X11 license:
# http://www.opensource.org/licenses/mit-license.php )
#
# Requires:
# * perl-5.8.x (may work with older versions)
# * The List::Util module.
# * The PDL module: http://pdl.perl.org/
#
# Version: 0.1.0

use strict;
use warnings;

use POSIX ();
use PDL;
use List::Util ();

use constant PI => (4 * atan2(1, 1));

sub square_wave
{
    my ($len, $height, $x_s) = @_;

    return [map {(POSIX::floor($_*$len)%2 == 0) ? $height : -$height } @$x_s];
}

sub primes
{
    my $n = shift;

    my @ret = (2);
    my $next = 3;
    MAIN:
    while (@ret != $n)
    {
        foreach (@ret)
        {
            if ($next % $_ == 0)
            {
                next MAIN;
            }
        }
    }
}

my $num = 100;
my @points = (map { $_ / $num } (-$num .. $num));

my $good = pdl([map { sin($_ * PI()) } @points]);

# my @lengths = ();

my $len = 1;

my @waves;

my $energy = ($good*$good)->average();
while ($energy > 0.0002)
{
    my $base = pdl(square_wave($len, 1, \@points));

    # The co-efficient to multiply
    # If we want min ||y-> - m*x->|| then we need to have
    # m = Sum[xy]/Sum[x^2]
    my $m = ($good * $base)->sum() / ($base*$base)->sum();
    push @waves, ([$len, $m]);
    $good -= $base*$m;
}
continue
{
    $energy = ($good*$good)->average();
    print "$energy\n";
    $len++;
}

open my $plot, ">", "gnuplot.dat";
my $x_num = 10_000;
foreach my $x_int (-$x_num .. $x_num)
{
    my $x = $x_int / $x_num;
    printf {$plot} ("%.10f %.10f\n", $x,
        List::Util::sum(
            map { @{square_wave(@$_, [$x])} } @waves
        ));
}
close($plot);

if (! -e "sinplot.dat")
{
open my $sin_plot, ">", "sinplot.dat";
foreach my $x_int (-10_000 .. 10_000)
{
    my $x = $x_int / 10_000;
    printf {$sin_plot} ("%.10f %.10f\n" , $x, sin($x*PI()));
}
close($sin_plot);
}
