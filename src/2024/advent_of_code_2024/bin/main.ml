(* DRIVER CODE: *)
let input_file = "/../share/advent_of_code_2024/input01.txt"
let input_path = Filename.dirname Sys.argv.(0) ^ input_file

let () =
  Core.In_channel.read_lines input_path
  |> Advent_of_code_2024.Day_01.part2
  |> print_int
