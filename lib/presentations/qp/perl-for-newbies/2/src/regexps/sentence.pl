use strict;
use warnings;

my $string = lc(shift(@ARGV));

if ($string =~ /the(?: +[a-z]+)* +there/)
{
    print "True\n";
}
else
{
    print "False\n";
}

