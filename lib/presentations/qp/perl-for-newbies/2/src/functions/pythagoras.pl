use strict;
use warnings;

sub pythagoras
{
    my ($x, $y);

    ($x, $y) = @_;

    return sqrt($x**2+$y**2);
}

print "The hypotenuse of a right triangle with sides 3 and 4 is ",
    pythagoras(3,4), "\n";
