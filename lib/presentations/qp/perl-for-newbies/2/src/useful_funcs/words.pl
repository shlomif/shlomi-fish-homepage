use strict;
use warnings;

my $sentence = shift;

my @words = split(/\s+/, $sentence);

my $i;
for($i=0;$i<scalar(@words);$i++)
{
    print "$i: " . $words[$i] . "\n";
}
