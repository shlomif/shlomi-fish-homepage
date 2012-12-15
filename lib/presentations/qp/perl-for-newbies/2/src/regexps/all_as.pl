
use strict;
use warnings;

my $string = shift;

if ($string =~ /^[Aa]*$/)
{
    print "The string you entered is all A's!\n";
}
else
{
    print "The string you entered is not all A's.\n";
}
