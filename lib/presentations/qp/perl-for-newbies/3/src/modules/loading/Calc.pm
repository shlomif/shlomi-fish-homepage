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
    my $a = shift;
    my $b = shift;

    if ($b > $a)
    {
        ($a, $b) = ($b , $a);
    }
    
    while ($a % $b > 0)
    {
        ($a, $b) = ($b, $a % $b);
    }

    return $b;
}

1;

