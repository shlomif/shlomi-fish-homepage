# This is MyModule.pm
package MyModule;

use strict;
use warnings;

sub add
{
    my ($x, $y) = @_;

    return $x+$y*2;
}

1;
