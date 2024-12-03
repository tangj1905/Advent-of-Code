(* HELPER FUNCTIONS *)
let rgx =
  (* Equivalent to /(\d+)\w+(\d+)/ in regex terms... *)
  let open Re in
  compile (seq [group(rep1 digit); rep1 space; group(rep1 digit)]);;

let parse_line (line: string) =
  let grps = Re.exec_opt rgx line in
  Option.map (fun g -> (int_of_string(Re.Group.get g 1), int_of_string(Re.Group.get g 2))) grps;;

let parse_inputs (input: string list) =
  input |> List.filter_map parse_line |> List.split 

(* DRIVER CODE *)
let part1 (lines: string list) =
  let (a, b) = parse_inputs lines in
  let std_a = List.sort compare a in
  let std_b = List.sort compare b in
  List.map2 (fun x y -> abs (x - y)) std_a std_b
    |> List.fold_left (+) 0;;

let part2 (lines: string list) =
  let (a, b) = parse_inputs lines in
  let freq_b = Core.Hashtbl.group (module Core.Int)
    ~get_key: Fun.id
    ~get_data: (Fun.const 1)
    ~combine: (+)
    b in

  let similarity x = match Core.Hashtbl.find freq_b x with
    | Some freq -> freq * x
    | None -> 0 in
    
  List.map similarity a
    |> List.fold_left (+) 0;;
