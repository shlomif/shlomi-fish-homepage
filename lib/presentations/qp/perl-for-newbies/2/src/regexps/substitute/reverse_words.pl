use strict;
use warnings;

my $string = shift;

$string =~ s/^([A-Za-z]+) *([A-Za-z]+)/$2 $1/;

print $string, "\n";
