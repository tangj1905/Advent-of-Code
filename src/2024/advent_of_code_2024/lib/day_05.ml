open Core

(* HELPER FUNCTIONS *)
let parse input =
  let deps, seqs = List.split_while input ~f:(Fn.non String.is_empty) in
  let dep_set = Hash_set.of_list (module String) deps in

  let cmp a b =
    if Hash_set.mem dep_set (a ^ "|" ^ b) then -1
    else if Hash_set.mem dep_set (b ^ "|" ^ a) then 1
    else 0
  in

  let seq_lst = seqs |> List.tl_exn |> List.map ~f:(String.split ~on:',') in

  (seq_lst, cmp)

let mid_pt lst = List.nth_exn lst (List.length lst / 2)

(* DRIVER CODE *)
module Part_1 = struct
  (* Part 1: Ignore transitivity! *)
  let solve (lines : string list) =
    let seqs, cmp = parse lines in

    List.filter seqs ~f:(List.is_sorted ~compare:cmp)
    |> List.map ~f:mid_pt
    |> List.sum (module Int) ~f:int_of_string
    |> string_of_int
end

module Part_2 = struct
  (* Part 2: Same thing! *)
  let solve (lines : string list) =
    let seqs, cmp = parse lines in

    List.filter seqs ~f:(Fn.non (List.is_sorted ~compare:cmp))
    |> List.map ~f:(fun lst -> List.sort lst ~compare:cmp |> mid_pt)
    |> List.sum (module Int) ~f:int_of_string
    |> string_of_int
end

(* TESTING *)
let example =
  String.split_lines
    {|47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
|}

let%test_unit "part_1_example" = [%test_eq: string] (Part_1.solve example) "143"
let%test_unit "part_2_example" = [%test_eq: string] (Part_2.solve example) "123"
