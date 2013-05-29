use strict;
use warnings;

my $string = lc(shift(@ARGV));

if ($string =~ /"([a-zA-Z]+|[0-9]+)( +([a-zA-Z]+|[0-9]+))*"/)
{
    print "True\n";
}
else
{
    print "False\n";
}
