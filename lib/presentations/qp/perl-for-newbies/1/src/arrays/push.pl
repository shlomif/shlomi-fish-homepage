

# Put 2 as the first prime so we won't have an empty array,
# what might confuse the interpreter
@primes = (2);

MAIN_LOOP:
for $number_to_check (3 .. 200)
{
    foreach $p (@primes)
    {
        if ($number_to_check % $p == 0)
        {
            next MAIN_LOOP;
        }
    }

    # If we reached this point it means $number_to_check is not
    # divisible by any prime number that came before it.
    push @primes, $number_to_check;
}

foreach $p (@primes)
{
    print $p, ", ";
}
print "\n";
