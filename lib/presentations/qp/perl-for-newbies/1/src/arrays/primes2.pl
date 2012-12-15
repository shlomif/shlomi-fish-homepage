

# Put 2 as the first prime so we won't have an empty array,
# what might confuse the interpreter
$primes[0] = 2;

MAIN_LOOP:
for $number_to_check (3 .. 200)
{
    for $p (0 .. $#primes)
    {
        if ($number_to_check % $primes[$p] == 0)
        {
            next MAIN_LOOP;
        }
    }

    # If we reached this point it means $number_to_check is not
    # divisible by any prime number that came before it.
    $primes[scalar(@primes)] = $number_to_check;
}

for $p (0 .. $#primes)
{
    print $primes[$p], ", ";
}
print "\n";
