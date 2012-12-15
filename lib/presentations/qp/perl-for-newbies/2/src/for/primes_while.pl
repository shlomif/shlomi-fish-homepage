
@primes = (2);
$i = 3;
MAIN_LOOP:
while (scalar(@primes) < 200)
{
    foreach $p (@primes)
    {
        if ($i % $p == 0)
        {
            next MAIN_LOOP;
        }
    }

    push @primes, $i;
    $i++;
}

print join(", " , @primes), "\n";
