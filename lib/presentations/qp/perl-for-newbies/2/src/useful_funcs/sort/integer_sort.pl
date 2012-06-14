use strict;
use warnings;

my @array = (100,5,8,92,-7,34,29,58,8,10,24);

my @sorted_array =
    (sort
        {
            if ($a < $b)
            {
                return -1;
            }
            elsif ($a > $b)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
        @array
    );

print join(",", @sorted_array), "\n";
