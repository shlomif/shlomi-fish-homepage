@primes1 = (2,3,5);
@primes2 = (7,11,13);
@primes = (@primes1,@primes2,17);
@primes = (@primes,19);

for $idx (0 .. $#primes)
{
    print $primes[$idx], "\n";
}
