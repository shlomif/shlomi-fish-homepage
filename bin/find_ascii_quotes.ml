
open Xmlm

let find_quotes input filename =
    let el tag list = () in
    let data str =
        let row,col = Xmlm.pos input in
        let lines = (Str.split (Str.regexp "\n") str) in
        let rec iter rest idx = if rest != [] then begin
            let line = (List.hd rest) in
            if String.contains line '"' then begin
                Printf.printf "%s:%d:%s\n" filename (row+idx) line
            end ;
            (iter (List.tl rest) (idx+1))
            end in
        iter lines 0 in
    Xmlm.input_doc_tree ~el ~data input;;

let () =
     Array.iter (fun filename ->
	let ic = open_in filename in
	ignore (find_quotes
		(Xmlm.make_input ~entity:(fun e -> Some e) (`Channel ic))
		filename))
       (Array.sub Sys.argv 1 (Array.length Sys.argv - 1))

