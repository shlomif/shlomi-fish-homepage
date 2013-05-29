use strict;
use warnings;

my @primes = (2);
for(my $n=3 ; scalar(@primes) < 100 ; $n++)
{
    if (scalar(grep { $n % $_ == 0 ; } @primes) == 0)
    {
        push @primes, $n;
    }
}
print join(", ", @primes), "\n";
