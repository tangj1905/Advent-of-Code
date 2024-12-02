open Core

(* HELPER FUNCTIONS *)
let example = {|
3   4
4   3
2   5
1   3
3   9
3   3
|} |> String.split_lines

let rgx =
  (* Equivalent to /(\d+)\w+(\d+)/ in regex terms... *)
  let open Re in
  compile (seq [group(rep1 digit); rep1 space; group(rep1 digit)]);;

let parse_inputs lines =
  (* Parses the input into a pair of columns: *)
  let parse_line line =
    let grps = Re.exec_opt rgx line in
    Option.map
      ~f: (fun g -> (int_of_string(Re.Group.get g 1), int_of_string(Re.Group.get g 2)))
      grps in
  lines |> List.filter_map ~f: parse_line |> List.unzip 


(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: sort each input list & add the absolute differences *)
  let solve (lines: string list) =
    let (a, b) = parse_inputs lines in
    let std_a = List.sort ~compare: compare a in
    let std_b = List.sort ~compare: compare b in
    
    List.map2_exn std_a std_b ~f: (fun x y -> abs (x - y))
     |> List.fold_left ~init: 0 ~f: (+)
     |> string_of_int;;

  let%test_unit "example" =
    [%test_eq: string] (solve example) "11"
end


module Part_2 = struct
  (* Part 2: Get a frequency count for elements in the second list *)
  let solve (lines: string list) =
    (* Get a frequency count for elements in the second list: *)
    let (a, b) = parse_inputs lines in
    let freq_b = Hashtbl.group (module Int)
      ~get_key: Fun.id
      ~get_data: (Fun.const 1)
      ~combine: (+)
      b in
  
    let similarity x = match Hashtbl.find freq_b x with
      | Some freq -> freq * x
      | None -> 0 in
      
    List.map ~f: similarity a
      |> List.fold_left ~init: 0 ~f: (+)
      |> string_of_int;;

  let%test_unit "example" =
    [%test_eq: string] (solve example) "31"
end
