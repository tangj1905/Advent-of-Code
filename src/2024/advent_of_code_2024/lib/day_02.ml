open Core

(* HELPER FUNCTIONS *)
let to_ints line =
  String.split line ~on: ' '
  |> List.map ~f: int_of_string
  |> Array.of_list

let is_safe xs =
  let sgn = compare xs.(0) xs.(1) in
  let unsafe_jump x y =
    x = y || (compare x y) <> sgn || abs(x - y) > 3 in
  not (Array.existsi xs ~f: (fun i x -> i > 0 && unsafe_jump xs.(i - 1) x))


(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Compare consecutive elements *) 
  let solve (lines: string list) =
    lines
    |> List.map ~f: to_ints
    |> List.count ~f: is_safe
    |> string_of_int
end


module Part_2 = struct
  (* Part 2: Same thing, but try removing an unsafe element *)
  let drop_i xs i =
    Array.append (Base.Array.subo ~pos: 0 ~len: i xs) (Base.Array.subo ~pos: (i + 1) xs)

  let is_very_safe xs =
    xs
    |> Array.mapi ~f: (fun i _ -> drop_i xs i)
    |> Array.exists ~f: is_safe

  let solve (lines: string list) =
    lines
    |> List.map ~f: to_ints
    |> List.count ~f: is_very_safe
    |> string_of_int
end


(* TESTING *)
let example = String.split_lines(
{|7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
|})

let%test_unit "part_1_example" =
  [%test_eq: string] (Part_1.solve example) "2"

let%test_unit "part_2_example" =
  [%test_eq: string] (Part_2.solve example) "4"
