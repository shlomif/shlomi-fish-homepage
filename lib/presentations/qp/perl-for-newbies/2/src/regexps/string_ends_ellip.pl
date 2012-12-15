use strict;
use warnings;

my $string = shift;

if ($string =~ /\.\.\. *$/)
{
    print "The string you entered ends with an ellipsis.\n";
}
else
{
    print "The string you entered does not end with an ellipsis.\n";
}
