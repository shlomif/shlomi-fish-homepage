package Bar2;

use strict;
use warnings;

use vars qw(@ISA);

use Foo;

@ISA=qw(Foo);

sub assign_name
{
    my $self = shift;

    my $name = shift;

    # Call the method of the base class
    my $ret = $self->SUPER::assign_name($name);
    if (! $ret)
    {
        $self->{'num_times'}++;
    }

    return $ret;
}

sub get_num_times_assigned
{
    my $self = shift;

    return
        (exists($self->{'num_times'}) ?
            $self->{'num_times'} :
            0
        );
}

1;

