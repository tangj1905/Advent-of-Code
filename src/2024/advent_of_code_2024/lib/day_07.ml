open Core

(* HELPER FUNCTIONS *)
let ( || ) a b =
  let rec up10 pow = if pow > b then pow else up10 (10 * pow) in
  (a * up10 10) + b

let parse_line ln =
  let tgt, nums = String.lsplit2_exn ln ~on:':' in
  let num_lst =
    String.lstrip nums |> String.split ~on:' ' |> List.rev_map ~f:int_of_string
  in
  (int_of_string tgt, num_lst)

let rec gen_solutions nums ops =
  let open List in
  match nums with
  | x :: [] -> [ x ]
  | x :: xs ->
      gen_solutions xs ops >>= fun s -> List.map ops ~f:(fun f -> f s x)
  | _ -> assert false

(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Generate solutions recursively *)
  let solve (lines : string list) =
    lines |> List.map ~f:parse_line
    |> List.filter ~f:(fun (res, nums) ->
           List.mem (gen_solutions nums [ ( * ); ( + ) ]) res ~equal)
    |> List.sum (module Int) ~f:fst
    |> string_of_int
end

module Part_2 = struct
  (* Part 2: Same thing! *)
  let solve (lines : string list) =
    lines |> List.map ~f:parse_line
    |> List.filter ~f:(fun (res, nums) ->
           List.mem (gen_solutions nums [ ( * ); ( + ); ( || ) ]) res ~equal)
    |> List.sum (module Int) ~f:fst
    |> string_of_int
end

(* TESTING *)
let example =
  String.split_lines
    {|190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
|}

let%test_unit "part_1_example" =
  [%test_eq: string] (Part_1.solve example) "3749"

let%test_unit "part_2_example" =
  [%test_eq: string] (Part_2.solve example) "11387"
