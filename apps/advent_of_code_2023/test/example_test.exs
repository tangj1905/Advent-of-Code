defmodule AdventTester do
  use ExUnit.Case

  # A convenience sigil to convert a multiline
  # heredoc to a list of lines:
  defp sigil_l(str, []), do: String.split(str, ["\r", "\n"], trim: true)

  import AdventOfCode2023.Day03

  test "part1" do
    input = ~l"""
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
      """
    assert part1(input) == 4361
  end

  test "part2" do
    input = ~l"""
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
      """

    assert part2(input) == 467835
  end
end
