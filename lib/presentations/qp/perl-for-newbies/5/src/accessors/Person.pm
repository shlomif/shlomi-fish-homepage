package Person;

use strict;
use warnings;

sub new
{
    my $class = shift;

    my $self = {};
    bless $self, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my $self = shift;
    my $args = shift;

    $self->_first_name($args->{'first_name'});
    $self->_last_name($args->{'last_name'});

    $self->_age($args->{'age'});

    return;
}

sub _first_name
{
    my $self = shift;

    if (@_)
    {
        my $new_first_name = shift;
        $self->{'_first_name'} = $new_first_name;
    }

    return $self->{'_first_name'};
}

sub _last_name
{
    my $self = shift;

    if (@_)
    {
        my $new_last_name = shift;
        $self->{'_last_name'} = $new_last_name;
    }

    return $self->{'_last_name'};
}

sub _age
{
    my $self = shift;

    if (@_)
    {
        my $new_age = shift;
        $self->{'_age'} = $new_age;
    }

    return $self->{'_age'};
}

sub greet
{
    my $self = shift;

    print "Hello ", $self->_first_name(), " ", $self->_last_name(), "\n";

    return;
}

sub increment_age
{
    my $self = shift;

    $self->_age($self->_age()+1);

    return;
}

sub get_age
{
    my $self = shift;

    return $self->_age();
}

1;
