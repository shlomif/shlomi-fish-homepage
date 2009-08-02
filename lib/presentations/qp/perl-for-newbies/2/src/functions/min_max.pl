use strict;
use warnings;

sub min_and_max
{
    my (@numbers);

    @numbers = @_;

    my ($min, $max);

    $min = $numbers[0];
    $max = $numbers[0];

    foreach my $i (@numbers)
    {
        if ($i > $max)
        {
            $max = $i;
        }
        elsif ($i < $min)
        {
            $min = $i;
        }
    }

    return ($min, $max);
}

my (@test_array, @ret);
@test_array = (123, 23 , -6, 7 , 80, 300, 45, 2, 9, 1000, -90, 3);

@ret = min_and_max(@test_array);

print "The minimum is ", $ret[0], "\n";
print "The maximum is ", $ret[1], "\n";
