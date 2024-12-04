(* HELPER FUNCTIONS *)
let parse_grid lines =
  let to_ints l =
    String.split_on_char ' ' l |> List.map int_of_string |> Array.of_list in
  lines |> List.map to_ints |> Array.of_list;;

let is_safe xs =
  let rec check xs dif =
    match xs with
    | x0 :: x1 :: tl -> x0 - x1 < dif && check (x1 :: tl) dif
    | _ -> true in

  match xs with
  | x0 :: x1 :: _ -> check xs (compare x0 x1)
  | _ -> true;;


(* DRIVER CODE *)
let part1 (input: string list) =
  let grid = parse_grid(input) in
  grid;;