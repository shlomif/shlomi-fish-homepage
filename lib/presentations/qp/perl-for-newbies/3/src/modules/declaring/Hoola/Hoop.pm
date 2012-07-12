# This is the file Hoola/Hoop.pm
#

package Hoola::Hoop;

use strict;
use warnings;

my $counter = 0;

sub get_counter
{
    return $counter++;
}

1;

