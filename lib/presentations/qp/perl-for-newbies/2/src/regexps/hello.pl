use strict;
use warnings;

my $string = shift(@ARGV);

if ($string =~ /hello/)
{
    print "The string contains the word \"hello\".\n";
}
else
{
    print "The string does not contain the word \"hello\".\n";
}
