MAIN_LOOP: for(
    @primes=(2), $i=3 ;
    scalar(@primes) < 200 ;
    $i++
    )
{
    foreach $p (@primes)
    {
        if ($i % $p == 0)
        {
            next MAIN_LOOP;
        }
    }

    push @primes, $i;
}

print join(", " , @primes), "\n";
