use strict;
use warnings;

my $string = shift;

$string =~ s/^([A-Za-z]+)/length($1)/e;

print $string, "\n";
