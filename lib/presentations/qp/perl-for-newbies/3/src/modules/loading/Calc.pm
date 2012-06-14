# File: Calc.pm
#
package Calc;

use strict;
use warnings;

use Exporter;

use vars qw(@ISA @EXPORT);

@ISA=qw(Exporter);

@EXPORT=("gcd");

# This function calculates the greatest common divisor of two integers
sub gcd
{
    my $m = shift;
    my $n = shift;

    if ($n > $m)
    {
        ($m, $n) = ($n , $m);
    }

    while ($m % $n > 0)
    {
        ($m, $n) = ($n, $m % $n);
    }

    return $n;
}

1;

