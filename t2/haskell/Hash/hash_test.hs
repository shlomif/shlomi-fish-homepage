import Hash
import MD5
import Array



myhash :: StringToStringHash
myhash = (MyHash
            (\s ->
                let x = fst(s) in (ord(x!!0)+256*(ord(x!!1)+256*(ord(x!!2))))
            )
            (\s1 -> \s2 ->
                (let x = fst(s1)
                     y = fst(s2) in
                     (if x < y then -1 else if x > y then 1 else 0)
                )
            )
            100
            (array (0,99) [ (i,[]) | i <- [0 .. 99]])
            0
         )
--            myarrray :: Array Int [(Int,Int)]
--            myarray = (array (0,99) [ (i,[]) | i <- [0 .. 99]])

new_hash :: StringToStringHash

new_hash = (insert (insert (insert myhash ("hello","you")) ("world","dodo")) ("yod","hoola"))

novell_hash = (remove new_hash ("hello","wow"))

hash2 = (replace_or_add new_hash ("world","hoola"))

hash3 = (rehash hash2 20)
