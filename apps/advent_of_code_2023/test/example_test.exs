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

  import AdventOfCode2023.Day13

  # @tag :skip
  test "part1" do
    input = ~l"""
      #.##..##.
      ..#.##.#.
      ##......#
      ##......#
      ..#.##.#.
      ..##..##.
      #.#.##.#.

      #...##..#
      #....#..#
      ..##..###
      #####.##.
      #####.##.
      ..##..###
      #....#..#
      """

    assert part1(input) == 405
  end

  # @tag :skip
  test "part2" do
    input = ~l"""
      #.##..##.
      ..#.##.#.
      ##......#
      ##......#
      ..#.##.#.
      ..##..##.
      #.#.##.#.

      #...##..#
      #....#..#
      ..##..###
      #####.##.
      #####.##.
      ..##..###
      #....#..#
      """

    assert part2(input) == 400
  end
end
