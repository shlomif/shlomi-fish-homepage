use strict;
use warnings;

my $string = lc(shift(@ARGV));

if ($string =~ /l...x/)
{
    print "True\n";
}
else
{
    print "False\n";
}
