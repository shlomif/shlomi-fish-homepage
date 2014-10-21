use strict;
use warnings;

my @array = (20, 3, 1, 9, 100, 88, 75);

my @new_array = (map { $_*2; } @array);

print join(",", @new_array), "\n";
