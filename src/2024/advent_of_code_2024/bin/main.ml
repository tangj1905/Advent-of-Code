open Core

(* DRIVER CODE *)
let argv = Sys.get_argv ()

module type Solver = sig
  val solve : string list -> string
end

module S =
  (val match argv with
       | [| _; "01"; "1" |] -> (module Advent_of_code_2024.Day_01.Part_1)
       | [| _; "01"; "2" |] -> (module Advent_of_code_2024.Day_01.Part_2)
       | [| _; "02"; "1" |] -> (module Advent_of_code_2024.Day_02.Part_1)
       | [| _; "02"; "2" |] -> (module Advent_of_code_2024.Day_02.Part_2)
       | [| _; "03"; "1" |] -> (module Advent_of_code_2024.Day_03.Part_1)
       | [| _; "03"; "2" |] -> (module Advent_of_code_2024.Day_03.Part_2)
       | [| _; "04"; "1" |] -> (module Advent_of_code_2024.Day_04.Part_1)
       | [| _; "04"; "2" |] -> (module Advent_of_code_2024.Day_04.Part_2)
       | [| _; "05"; "1" |] -> (module Advent_of_code_2024.Day_05.Part_1)
       | [| _; "05"; "2" |] -> (module Advent_of_code_2024.Day_05.Part_2)
       | [| _; "06"; "1" |] -> (module Advent_of_code_2024.Day_06.Part_1)
       | [| _; "06"; "2" |] -> (module Advent_of_code_2024.Day_06.Part_2)
       | [| _; "07"; "1" |] -> (module Advent_of_code_2024.Day_07.Part_1)
       | [| _; "07"; "2" |] -> (module Advent_of_code_2024.Day_07.Part_2)
       | [| _; "08"; "1" |] -> (module Advent_of_code_2024.Day_08.Part_1)
       | [| _; "08"; "2" |] -> (module Advent_of_code_2024.Day_08.Part_2)
       | _ -> invalid_arg "Args: <day> <part>"
      : Solver)

let input_file =
  Printf.sprintf "/../share/advent_of_code_2024/input%s.txt" argv.(1)

let input_path = Filename.dirname argv.(0) ^ input_file

let () =
  let open Int63 in
  let input = In_channel.read_lines input_path in
  let t0 = Time_now.nanosecond_counter_for_timing () in
  let solution = S.solve input in
  let t1 = Time_now.nanosecond_counter_for_timing () in
  let micros = (t1 - t0) / of_int 1000 in
  Printf.printf "Solution: %s\nFinished in %s us\n" solution (to_string micros)
