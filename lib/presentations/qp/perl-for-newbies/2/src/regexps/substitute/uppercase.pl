use strict;
use warnings;

my $string = shift;

$string =~ s/([Ss][A-Za-z]*)/'<'.uc($1).'>'/e;

print $string, "\n";
