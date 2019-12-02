import Array

hist            :: (Ix a, Integral b) => (a,a) -> [a] -> Array a b
hist bnds is    =  accumArray (+) 0 bnds [(i, 1) | i <- is, inRange bnds i]

result = hist (0,10) [
    1,1,1,1 ,
    2,2,2 ,
    3,3 ,
    4,4,4,4,4,4,4,4 ,
    5,5,
    6,6,6,6,6,
    7,
    8,8,8,8,8,
    9,9,9,
    10
    ]
