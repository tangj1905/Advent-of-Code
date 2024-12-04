(* DRIVER CODE *)
module type Solver = sig
  val solve: string list -> string
end

module S =
  (val (match Sys.argv with
    | [| _; "01"; "1" |] -> (module Advent_of_code_2024.Day_01.Part_1)
    | [| _; "01"; "2" |] -> (module Advent_of_code_2024.Day_01.Part_2)
    | _ -> invalid_arg "Args: <day> <part>"): Solver)

let input_file = Printf.sprintf "/../share/advent_of_code_2024/input%s.txt" Sys.argv.(2)
let input_path = Filename.dirname Sys.argv.(0) ^ input_file

let () =
  Core.In_channel.read_lines input_path
  |> S.solve
  |> print_endline
