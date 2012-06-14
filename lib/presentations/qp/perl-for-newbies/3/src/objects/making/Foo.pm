#
# Foo.pm
#
package Foo;

use strict;
use warnings;

sub new
{
    # Retrieve the package's string.
    # It is not necessarily Foo, because this constructor may be
    # called from a class that inherits Foo.
    my $class = shift;

    # $self is the the object. Let's initialize it to an empty hash
    # reference.
    my $self = {};

    # Associate $self with the class $class. This is probably the most
    # important step.
    bless $self, $class;

    # Now we can retrieve the other arguments passed to the
    # constructor.

    my $name = shift || "Fooish";
    my $number = shift || 5;

    # Put these arguments inside class members
    $self->{'name'} = $name;
    $self->{'number'} = $number;

    # Return $self so the user can use it.
    return $self;
}

sub get_name
{
    # This step is necessary so it will be treated as a method
    my $self = shift;

    return $self->{'name'};
}

sub assign_name
{
    my $self = shift;

    # Notice that we can pass regular arguments from now on.
    my $new_name = shift || "Fooish";

    $self->{'name'} = $new_name;

    return 0;
}

1;

