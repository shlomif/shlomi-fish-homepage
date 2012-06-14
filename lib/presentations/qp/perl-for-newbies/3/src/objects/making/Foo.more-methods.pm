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

