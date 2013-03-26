use strict;
use warnings;

my $string = lc(shift(@ARGV));

if ($string =~ /\[\{[0-9]+(?:,[0-9]+)+\}(?:;\{(?:[0-9]+(?:,[0-9]+)+)\})+\]/)
{
    print "True\n";
}
else
{
    print "False\n";
}

