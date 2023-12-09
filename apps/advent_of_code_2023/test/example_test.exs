defmodule AdventTester do
  use ExUnit.Case

  # A convenience sigil to convert a multiline
  # heredoc to a list of lines:
  defp sigil_l(str, []) do
    str
    |> String.trim_trailing()
    |> String.split("\r\n")
    |> Enum.map(&String.trim/1)
  end

  import AdventOfCode2023.Day09

  # @tag :skip
  test "part1" do
    input = ~l"""
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
      """

    assert part1(input) == 114
  end

  # @tag :skip
  test "part2" do
    input = ~l"""
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
      """

    assert part2(input) == 2
  end
end
