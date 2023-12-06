defmodule AdventTester do
  use ExUnit.Case

  # A convenience sigil to convert a multiline
  # heredoc to a list of lines:
  defp sigil_l(str, []), do:
    str |> String.split("\r\n") |> Enum.map(&String.trim/1)

  import AdventOfCode2023.Day06

  # @tag :skip
  test "part1" do
    input = ~l"""
      Time:      7  15   30
      Distance:  9  40  200
      """

    assert part1(input) == 288
  end

  # @tag :skip
  test "part2" do
    input = ~l"""
      Time:      7  15   30
      Distance:  9  40  200
      """

    assert part2(input) == 71503
  end
end
