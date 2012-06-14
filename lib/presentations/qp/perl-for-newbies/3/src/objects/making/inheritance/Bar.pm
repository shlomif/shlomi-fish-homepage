package Bar;

use strict;
use warnings;

# @ISA is not lexically scoped so it has to be declared with
# use vars.
#
# qw(My Constant String) is equivalent to split(/\s+/, "My Constant String")
use vars qw(@ISA);

# We use Foo during our inheritance so we should load it.
use Foo;

# This command actually inherits Foo.
@ISA=qw(Foo);

sub assign_name_ext
{
    my $self = shift;

    my $name = shift;

    # Call the method of the base class
    my $ret = $self->assign_name($name);
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

