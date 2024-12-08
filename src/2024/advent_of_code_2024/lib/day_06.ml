open Core

(* HELPER FUNCTIONS - POINT UTILS *)
module Pt = struct
  include Tuple.Comparator (Int) (Int)
  include Tuple.Comparable (Int) (Int)
  include Tuple.Hashable (Int) (Int)
end

module PtDir = struct
  include Tuple.Comparator (Pt) (Pt)
  include Tuple.Comparable (Pt) (Pt)
  include Tuple.Hashable (Pt) (Pt)
end

let ( + ) (i, j) (di, dj) = (i + di, j + dj)
let rotate (di, dj) = (dj, -di)

(* HELPER FUNCTIONS - TRAVERSAL UTILS *)
let to_grid lines = lines |> List.to_array |> Array.map ~f:String.to_array
let grid_get grid (i, j) = try grid.(i).(j) with _ -> 'E'
let grid_set grid (i, j) elt = Array.set grid.(i) j elt

let init_pt grid =
  let pt =
    Array.find_mapi grid ~f:(fun i row ->
        Array.find_mapi row ~f:(fun j elt ->
            Option.some_if (equal_char elt '^') (i, j)))
  in
  Option.value_exn pt

let rec walk grid vis pt dir =
  if Hash_set.mem vis (pt, dir) then true
  else if equal_char (grid_get grid pt) 'E' then false
  else
    let nxt_pt, nxt_dir =
      Hash_set.add vis (pt, dir);
      match grid_get grid (pt + dir) with
      | '#' -> (pt, rotate dir)
      | _ -> (pt + dir, dir)
    in
    walk grid vis nxt_pt nxt_dir

(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Walk the grid, memoizing point & direction faced *)
  let solve (lines : string list) =
    let grid = to_grid lines in
    let init_pt = init_pt grid in
    let init_dir = (-1, 0) in
    let vis = Hash_set.create (module PtDir) in
    let _ = walk grid vis init_pt init_dir in

    let pts =
      Hash_set.to_list vis |> List.map ~f:fst |> Hash_set.of_list (module Pt)
    in

    pts |> Hash_set.length |> string_of_int
end

module Part_2 = struct
  (* Part 2: Try placing an obstacle everywhere along the path *)
  let solve (lines : string list) =
    let grid = to_grid lines in
    let init_pt = init_pt grid in
    let init_dir = (-1, 0) in
    let vis = Hash_set.create (module PtDir) in
    let _ = walk grid vis init_pt init_dir in

    let pts =
      Hash_set.to_list vis |> List.map ~f:fst |> Hash_set.of_list (module Pt)
    in

    Hash_set.remove pts init_pt;
    Hash_set.count pts ~f:(fun pt ->
        let is_loop =
          grid_set grid pt '#';
          walk grid (Hash_set.create (module PtDir)) init_pt init_dir
        in
        grid_set grid pt '.';
        is_loop)
    |> string_of_int
end

(* TESTING *)
let example =
  String.split_lines
    {|....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
|}

let%test_unit "part_1_example" = [%test_eq: string] (Part_1.solve example) "41"
let%test_unit "part_2_example" = [%test_eq: string] (Part_2.solve example) "6"
