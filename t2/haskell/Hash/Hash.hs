module Hash where

import Array

data Hash hash_function compare_function size table num_elems =
    MyHash hash_function compare_function size table num_elems

get_hash_function (MyHash hash_function compare_function size table num_elems) = hash_function

get_compare_function (MyHash hash_function compare_function size table num_elems) = compare_function

get_size (MyHash hash_function compare_function size table num_elems) = size

get_table (MyHash hash_function compare_function size table num_elems) = table

get_num_elems (MyHash hash_function compare_function size table num_elems) = num_elems

type IntHash = Hash (Int -> Int) (Int -> Int -> Int) Int (Array Int [(Int,Int)]) Int

type StringHash = Hash (String -> Int) (String -> String -> Int) Int (Array Int [(Int,String)]) Int

type StringToString = (String,String)

type StringToStringHash = Hash (StringToString -> Int) (StringToString -> StringToString -> Int) Int (Array Int [(Int,StringToString)]) Int

exists (MyHash hash_function compare_function size table num_elems) myelem =
    ((length
    (filter
        cmp_element
        (table!index)
    )) > 0) where
        hash_value = (hash_function myelem)
        index = (hash_value `mod` size)
        cmp_element x = (
                (hash_value == (fst x)) &&
                ((compare_function myelem (snd x)) == 0)
            )


insert (MyHash hash_function compare_function size table num_elems) myelem =
    (if (exists (MyHash hash_function compare_function size table num_elems) myelem)
    then (MyHash hash_function compare_function size table num_elems)
    else
    (MyHash
        hash_function
        compare_function
        size
        (table // [(index , new_list)])
        (num_elems+1)
    )) where
        hash_value = (hash_function myelem)
        index = (hash_value `mod` size)
        new_list = (hash_value,myelem):(table!index)

remove (MyHash hash_function compare_function size table num_elems) myelem =
    (MyHash
        hash_function
        compare_function
        size
        (table // [(index, new_list)])
        (if orig_len == length(new_list)
         then num_elems
         else (num_elems-1)
        )
    ) where
        hash_value = (hash_function myelem)
        index = (hash_value `mod` size)
        orig_len = length(table!index)
        cmp_element x = (
                (hash_value == (fst x)) &&
                ((compare_function myelem (snd x)) == 0)
            )
        new_list =
            (filter
                (\x -> (not(cmp_element x)))
                (table!index)
            )

get_value (MyHash hash_function compare_function size table num_elems) myelem =
    item_list where
        hash_value = (hash_function myelem)
        index = (hash_value `mod` size)
        cmp_element x = (
                (hash_value == (fst x)) &&
                ((compare_function myelem (snd x)) == 0)
            )
        item_list =
            [ snd(i) | i <- (filter cmp_element (table!index) ) ]

replace_or_add (MyHash hash_function compare_function size table num_elems) myelem =
    (MyHash
        hash_function
        compare_function
        size
        (table // [(index, new_list)])
        (if orig_len == length(new_list)
         then num_elems
         else (num_elems-1)
        )
    ) where
        hash_value = (hash_function myelem)
        index = (hash_value `mod` size)
        orig_len = length(table!index)
        cmp_element x = (
                (hash_value == (fst x)) &&
                ((compare_function myelem (snd x)) == 0)
            )
        new_list = (myreplace (table!index)) where
            myreplace :: [(Int,StringToString)] -> [(Int,StringToString)]
            myreplace [] = [(hash_value,myelem)]
            myreplace (a:as) =
                (if (cmp_element a)
                 then ((hash_value,myelem):as)
                 else (a:myreplace(as)))

get_all_values (MyHash hash_function compare_function size table num_elems) =
    [ snd(a) | i <- [ 0 .. (size-1) ] , a <- table!i ]

rehash (MyHash hash_function compare_function size table num_elems) new_size =
    (MyHash
        hash_function
        compare_function
        new_size
        new_table
        num_elems
    ) where
        new_table = (accumArray
            (\present -> \new_elem -> (new_elem:present))
            ]
            (0,(new_size-1))
            [   (hash_value `mod` new_size, (hash_value,elem)) |
                i <- [ 0 .. (size-1) ],
                (hash_value,elem) <- table!i
            ]
        )




-- This doesn't work. If you can get it to, Please let me know.

--instance Show StringToStringHash where
--    show (MyHash hash_function compare_function size table num_elems) =
--        iterate 0 where
--            iterate size = ""
--            iterate index = myaccumolate (table!index) ++ (iterate (index+1)) where
--                myaccumolate [] = "\n"
--                myaccumolate (a:as) = (show (snd a)) ++ (myaccumolate as)



