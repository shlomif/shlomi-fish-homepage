use strict;
use warnings;

my @array = (100,5,8,92,-7,34,29,58,8,10,24);

my @sorted_array = (sort { $a <=> $b } @array);

print join(",", @sorted_array), "\n";
