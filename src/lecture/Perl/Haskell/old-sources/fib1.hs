fib_pair :: Integer -> (Integer,Integer)
fib_pair 0 = (0,1)
fib_pair n = (b,a+b) where
    (a,b) = (fib_pair (n-1))

fib :: Integer -> Integer
fib n = (fst (fib_pair n))
