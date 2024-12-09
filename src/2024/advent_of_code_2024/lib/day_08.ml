open Core

(* HELPER FUNCTIONS *)
module Pt = struct
  include Tuple.Comparator (Int) (Int)
  include Tuple.Comparable (Int) (Int)
  include Tuple.Hashable (Int) (Int)
end

let ( + ) (i, j) (ii, jj) = (i + ii, j + jj)
let ( - ) (i, j) (ii, jj) = (i - ii, j - jj)
let to_grid lines = lines |> List.to_array |> Array.map ~f:String.to_array
let grid_get grid (i, j) = try grid.(i).(j) with _ -> '@'

let antennae grid =
  let pts =
    Array.concat_mapi grid ~f:(fun i row ->
        Array.filter_mapi row ~f:(fun j elt ->
            Option.some_if (not (equal_char elt '.')) (i, j)))
  in
  List.of_array pts

let rec antinodes f pts =
  match pts with
  | [] -> []
  | p :: ps -> List.append (List.bind ps ~f:(fun p0 -> f p p0)) (antinodes f ps)

(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Group points by satellite & iterate on every pair *)
  let solve (lines : string list) =
    let grid = to_grid lines in
    let points = antennae grid in

    let grps =
      List.sort_and_group points ~compare:(fun p1 p2 ->
          compare_char (grid_get grid p1) (grid_get grid p2))
    in

    let antinodes_from_pairs p0 p1 = [ p0 + p0 - p1; p1 + p1 - p0 ] in

    List.bind grps ~f:(antinodes antinodes_from_pairs)
    |> Hash_set.of_list (module Pt)
    |> Hash_set.count ~f:(fun p -> not (equal_char (grid_get grid p) '@'))
    |> string_of_int
end

module Part_2 = struct
  (* Part 2: Generate solutions recursively *)
  let solve (lines : string list) =
    let grid = to_grid lines in
    let points = antennae grid in

    let grps =
      List.sort_and_group points ~compare:(fun p1 p2 ->
          compare_char (grid_get grid p1) (grid_get grid p2))
    in

    let antinodes_from_pairs p0 p1 =
      let rec gen p dir =
        if equal_char (grid_get grid p) '@' then [] else p :: gen (p + dir) dir
      in
      let dir0, dir1 = (p1 - p0, p0 - p1) in
      List.append (gen (p0 + dir0) dir0) (gen (p1 + dir1) dir1)
    in

    List.bind grps ~f:(antinodes antinodes_from_pairs)
    |> Hash_set.of_list (module Pt)
    |> Hash_set.count ~f:(fun p -> not (equal_char (grid_get grid p) '@'))
    |> string_of_int
end

(* TESTING *)
let example =
  String.split_lines
    {|............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
|}

let%test_unit "part_1_example" = [%test_eq: string] (Part_1.solve example) "14"
let%test_unit "part_2_example" = [%test_eq: string] (Part_2.solve example) "34"
