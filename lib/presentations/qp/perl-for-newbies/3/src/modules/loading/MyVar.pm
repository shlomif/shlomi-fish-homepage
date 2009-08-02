# This file is MyVar.pm
#
package MyVar;

use strict;
use warnings;

# Declare a namespace-scoped variable named $myvar.
use vars qw($myvar);

sub print_myvar
{
    print $myvar, "\n";
}

1;
