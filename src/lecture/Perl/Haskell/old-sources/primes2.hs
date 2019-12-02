primes :: Int -> [Int]

primes how_much = sieve [2..how_much] where
         sieve (p:x) = p : (if p <= mybound
                            then sieve (remove (p*p) x)
                            else x) where
             remove what (a:as) | what > how_much = (a:as)
                                | a < what        = a:(remove what as)
                                | a == what       = (remove (what+step) as)
                                | a > what        = a:(remove (what+step) as)
             remove what [] = []
             step = (if (p == 2)
                     then p
                     else (2*p)
                    )
         sieve [] = []
         mybound = ceiling(sqrt(fromIntegral how_much))
