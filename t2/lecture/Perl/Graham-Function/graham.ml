let rec get_squaring_factors =
    let hash = Hashtbl.create 20 in
    fun n start_from ->
        try
            Hashtbl.find hash n
        with
        Not_found -> let v =
            (if n == 1 then
                []
            else
                (let rec div_and_add = fun p ->
                    (if n mod p == 0 then
                        match (get_squaring_factors (n / p) p) with
                            [] -> [ p ]
                            | (first :: others) ->
                                (if (first == p) then others
                                 else (p :: first :: others))
                    else
                        div_and_add(p+1))
                in div_and_add start_from
            )
            ) in
            (Hashtbl.replace hash n v;
            v)
;;


let rec multiply_squaring_factors  = fun n_ref m_ref ->
    match (n_ref,m_ref) with
        ([],n) -> n
        | (m,[]) -> m
        | ((m_first :: m_others) , (n_first :: n_others)) ->
            (if m_first == n_first then
                (multiply_squaring_factors m_others n_others)
            else if n_first < m_first then
                n_first :: (multiply_squaring_factors (m_first::m_others) n_others)
            else
                m_first :: (multiply_squaring_factors m_others (n_first :: n_others))
            )
            ;;



let rec print_int_list = function
    [] -> ()
    | x :: l -> print_int x; print_string " ; "; print_int_list l
    ;;

let nice_pil mylist =
    print_string "[" ; print_int_list mylist ; print_string "]"
    ;;

let mydebug1 num1 num2 =
    let num1_factors = (get_squaring_factors num1 2) in
        let num2_factors = (get_squaring_factors num2 2) in
            Printf.printf "First Number: %i\nFactors: " num1;
            nice_pil(num1_factors);
            Printf.printf "\nSecond Number: %i\nFactors: " num2;
            nice_pil(num2_factors);
            Printf.printf "\nTotal Factors: ";
            nice_pil(multiply_squaring_factors num1_factors num2_factors);
            Printf.printf "\n";
            ;;

let is_empty = function
    [] -> true
    | (a :: rest) -> false
    ;;

let rec member elem mylist =
    match mylist with
    [] -> false
    | (a :: rest) -> (if (elem == a) then true else (member elem rest))
    ;;

let rec list_min mylist =
    match mylist with
    [] -> raise Not_found
    | (a :: []) -> a
    | (a :: rest) -> min a (list_min rest);;

let first_item mylist =
    match mylist with
    [] -> raise Not_found
    | (a :: rest) -> a

let rec last_item  = function
    [] -> raise Not_found
    | (a :: []) -> a
    | (a :: rest) -> (last_item rest);;

let rec myproduct = function
    [] -> 1
    | (a :: rest) -> a * (myproduct rest)
    ;;

let int_square_root a = (int_of_float (sqrt (float_of_int a)));;

let graham n =
    let n_sq_factors = (get_squaring_factors n 2) in
        match n_sq_factors with
            [] -> n
            | n_sq_factors ->
                   let largest_factor = last_item n_sq_factors in
                   let lower_bound = n + largest_factor in
                   let lb_sq_factors = (get_squaring_factors lower_bound 2) in
                   let n_times_lb = multiply_squaring_factors n_sq_factors lb_sq_factors in
                   let rest_of_factors_product = (myproduct n_times_lb) in
                   if ((int_square_root (n / rest_of_factors_product)) !=
                       (int_square_root (lower_bound / rest_of_factors_product)))
                   then
                       lower_bound
                   else
                   (

                   let primes_to_ids_map : (int,int) Hashtbl.t = Hashtbl.create 37 in
                   let next_id = ref 0 in
                   let register_prime p =
                       Hashtbl.add primes_to_ids_map p !next_id ;
                       next_id := !next_id + 1; in
                   let base = (Array.make (2*n) []) in
                   let rec add_n_facts = function
                        [] -> ()
                        | (a :: rest ) ->
                            register_prime a;
                            add_n_facts rest;
                        in (add_n_facts n_sq_factors);

                   let rec iterate n_vec i =

                       let i_sq_factors = (get_squaring_factors i 2) in

                       if (is_empty i_sq_factors) ||
                          ((n > 2) && ((first_item i_sq_factors) == i)) then
                              (iterate n_vec (i+1))
                       else
                       (
                       let rec i_iterate final_vec rest_of_i =
                           (match rest_of_i with
                           [] -> final_vec
                           | (p :: rest) ->
                                   (try
                                     let id = (Hashtbl.find primes_to_ids_map p) in
                                        (i_iterate
                                             (multiply_squaring_factors
                                                final_vec
                                                base.(id)
                                             )
                                            rest
                                        )
                                   with
                                    Not_found ->
                                        register_prime p;
                                        (i_iterate final_vec rest)
                                    )
                           ) in

                       let final_vec = (i_iterate i_sq_factors i_sq_factors) in

                       let (min_id,min_p) = (let rec get_min_id (min_id,min_p) vec =
                           match vec with
                           [] -> (min_id, min_p)
                           | (p :: rest) -> let id = (Hashtbl.find primes_to_ids_map p) in let (new_id,new_p) = (if ((min_id < 0) || (min_id > id)) then (id,p) else (min_id,min_p)) in (get_min_id (new_id,new_p) rest)
                                in (get_min_id (-1,0) final_vec)) in
                       (if min_id >= 0 then
                           (
                           base.(min_id) <- final_vec;
                           for j=0 to (Array.length(base) - 1) do
                               if ((j != min_id) &&
                                  (List.mem min_p base.(j))
                                )
                               then
                                    base.(j) <-
                                        (multiply_squaring_factors
                                            base.(j)
                                            final_vec
                                        )
                                   else
                                       ()
                           done
                           )
                       else
                           ()
                       );

                       let rec canon_n_vec n_vec =
                           (if (is_empty n_vec) then
                               n_vec
                           else
                               let id = (list_min (List.map (function x -> Hashtbl.find primes_to_ids_map x) n_vec)) in
                               if (is_empty base.(id)) then
                                   n_vec
                               else
                                (canon_n_vec (multiply_squaring_factors n_vec base.(id)))
                           ) in
                        let new_n_vec = (canon_n_vec n_vec) in

                        (if (is_empty new_n_vec) then
                            i
                         else
                            (iterate new_n_vec (i+1))
                        )
                        )

                       in (iterate n_sq_factors (n+1))
                   )
;;

let mystart = (int_of_string Sys.argv.(1));;
let myend = if (Array.length(Sys.argv) > 2) then (int_of_string Sys.argv.(2)) else mystart;;

for n = mystart to myend do
    Printf.printf "G(%i) = %i\n" n (graham n);
done;;


