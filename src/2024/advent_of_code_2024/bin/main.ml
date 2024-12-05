(* DRIVER CODE *)
module type Solver = sig
  val solve: string list -> string
end

module S =
  (val (match Sys.argv with
    | [| _; "01"; "1" |] -> (module Advent_of_code_2024.Day_01.Part_1)
    | [| _; "01"; "2" |] -> (module Advent_of_code_2024.Day_01.Part_2)
    | [| _; "02"; "1" |] -> (module Advent_of_code_2024.Day_02.Part_1)
    | [| _; "02"; "2" |] -> (module Advent_of_code_2024.Day_02.Part_2)
    | [| _; "03"; "1" |] -> (module Advent_of_code_2024.Day_03.Part_1)
    | [| _; "03"; "2" |] -> (module Advent_of_code_2024.Day_03.Part_2)
    | [| _; "04"; "1" |] -> (module Advent_of_code_2024.Day_04.Part_1)
    | [| _; "04"; "2" |] -> (module Advent_of_code_2024.Day_04.Part_2)
    | _ -> invalid_arg "Args: <day> <part>"): Solver)

let input_file = Printf.sprintf "/../share/advent_of_code_2024/input%s.txt" Sys.argv.(1)
let input_path = Filename.dirname Sys.argv.(0) ^ input_file

let () =
  let solution = S.solve (Core.In_channel.read_lines input_path) in
  print_endline solution
