use strict;
use warnings;

my $num_disks = shift || 9;

my @towers = (
    [ reverse(1 .. $num_disks) ],  # A [ ... ] is a dynamic reference to
    [ ],                           # an array
    [ ]
    );

sub print_towers
{
    for(my $i=0 ; $i < 3 ; $i++)
    {
        print ": ";
        print join(" ", @{$towers[$i]}); # We de-reference the tower
        print "\n";
    }
    print "\n\n";
}

sub move_column
{
    my $source = shift;
    my $dest = shift;
    my $how_many = shift;

    if ($how_many == 0)
    {
        return;
    }
    # Find the third column
    my $intermediate = 0+1+2-$source-$dest;
    move_column($source, $intermediate, $how_many-1);
    # Print the current state
    print_towers();
    # Move one disk. Notice the dereferncing of the arrays
    # using @{$ref}.
    push @{$towers[$dest]}, pop(@{$towers[$source]});
    move_column($intermediate, $dest, $how_many-1);
}

# Move the entire column
move_column(0,1,$num_disks);
print_towers();
