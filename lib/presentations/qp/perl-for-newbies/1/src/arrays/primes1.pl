
$num_primes = 0;

# Put 2 as the first prime so we won't have an empty array,
# what might confuse the interpreter
$primes[$num_primes] = 2;
$num_primes++;

MAIN_LOOP:
for $number_to_check (3 .. 200)
{
    for $p (0 .. ($num_primes-1))
    {
        if ($number_to_check % $primes[$p] == 0)
        {
            next MAIN_LOOP;
        }
    }

    # If we reached this point it means $number_to_check is not
    # divisible by any prime number that came before it.
    $primes[$num_primes] = $number_to_check;
    $num_primes++;
}

for $p (0 .. ($num_primes-1))
{
    print $primes[$p], ", ";
}
print "\n";
