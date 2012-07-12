use strict;
use warnings;

my $sum = 0;

sub update_sum
{
    my $ref_to_sum = shift;
    foreach my $item (@_)
    {
        # The ${ ... } dereferences the variable
        ${$ref_to_sum} += $item;
    }
}

update_sum(\$sum, 5, 4, 9, 10, 11);
update_sum(\$sum, 100, 80, 7, 24);

print "\$sum is now ", $sum, "\n";
