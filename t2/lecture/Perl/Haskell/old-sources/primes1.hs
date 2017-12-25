primes = sieve [2 ..] where
    sieve (p:rest) = p:(sieve [ i | i <- rest, i `mod` p /= 0])
