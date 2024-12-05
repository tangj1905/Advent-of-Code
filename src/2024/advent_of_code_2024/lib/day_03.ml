open Core

(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Extract fields via regex *)
  let mul_expr =
    let open Re in
    seq [str "mul("; group (rep1 digit); str ","; group (rep1 digit); str ")"]
  let rgx = Re.compile mul_expr

  let eval_mul g =
    let open Re in
    let a = Group.get g 1 in
    let b = Group.get g 2 in
    (int_of_string a) * (int_of_string b)

  let solve (lines: string list) =
    lines
    |> List.bind ~f: (Re.all rgx)
    |> List.fold ~init: 0 ~f: (fun sum g -> sum + eval_mul g)
    |> string_of_int
end


module Part_2 = struct
  (* Part 2: Eliminate between don't and do: *)
  let do_expr = Re.str "do()"
  let dont_expr = Re.str "don't()"
  let rgx =
    let open Re in
    compile (seq [do_expr; non_greedy (rep any); dont_expr])

  let solve (lines: string list) =
    let instr = String.concat lines in
    let matches = Re.matches rgx ("do()" ^ instr ^ "don't()") in
    Part_1.solve matches
end


(* TESTING *)
let example = ["xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"]

let%test_unit "part_1_example" =
  [%test_eq: string] (Part_1.solve example) "161"

let%test_unit "part_2_example" =
  [%test_eq: string] (Part_2.solve example) "48"