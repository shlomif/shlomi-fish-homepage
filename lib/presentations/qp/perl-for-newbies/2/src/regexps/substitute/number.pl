use strict;
use warnings;

my $string = shift;

$string =~ s/[0-9]+/Some Number/;

print $string, "\n";
