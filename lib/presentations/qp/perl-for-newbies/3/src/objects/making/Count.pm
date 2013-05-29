package Count;

use strict;
use warnings;

use vars qw(@ISA);

use Bar2;

@ISA=qw(Bar2);

sub DESTROY
{
    my $self = shift;

    print "My name was assigned " . $self->get_num_times_assigned() . " times.\n";
}

1;

