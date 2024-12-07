open Core

(* HELPER FUNCTIONS *)
let to_grid lines = lines |> List.to_array |> Array.map ~f:String.to_array
let grid_get grid (i, j) = try grid.(i).(j) with _ -> '.'
let ( + ) (i, j) (di, dj) = (i + di, j + dj)

let rec traverse grid pos dir path =
  match path with
  | [] -> true
  | c :: cs when equal_char c (grid_get grid pos) ->
      traverse grid (pos + dir) dir cs
  | _ -> false

(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Basic brute-force search *)
  let dirs = List.cartesian_product [ -1; 0; 1 ] [ -1; 0; 1 ]
  let path = String.to_list "XMAS"
  let find grid pos = List.count dirs ~f:(fun dir -> traverse grid pos dir path)

  let solve (lines : string list) =
    let grid = to_grid lines in
    let m, n = (Array.length grid, Array.length grid.(0)) in
    let poss = List.cartesian_product (List.range 0 m) (List.range 0 n) in
    List.sum (module Int) poss ~f:(fun pos -> find grid pos) |> string_of_int
end

module Part_2 = struct
  (* Part 2: Same thing here *)
  let dir1, dir2 = ((-1, 1), (1, 1))
  let paths = [ String.to_list "MAS"; String.to_list "SAM" ]

  let find grid pos =
    let starts = [ (pos + (1, -1), dir1); (pos + (-1, -1), dir2) ] in
    List.for_all starts ~f:(fun (pos, dir) ->
        List.exists paths ~f:(fun path -> traverse grid pos dir path))

  let solve (lines : string list) =
    let grid = to_grid lines in
    let m, n = (Array.length grid, Array.length grid.(0)) in
    let poss = List.cartesian_product (List.range 0 m) (List.range 0 n) in
    List.count poss ~f:(fun pos -> find grid pos) |> string_of_int
end

(* TESTING *)
let example =
  String.split_lines
    {|MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
|}

let%test_unit "part_1_example" = [%test_eq: string] (Part_1.solve example) "18"
let%test_unit "part_2_example" = [%test_eq: string] (Part_2.solve example) "9"
