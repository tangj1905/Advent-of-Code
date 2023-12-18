defmodule AdventTester do
  use ExUnit.Case

  # A convenience sigil to convert a multiline
  # heredoc to a list of lines:
  defp sigil_L(str, []) do
    str
    |> String.trim_trailing()
    |> String.split("\r\n")
    |> Enum.map(&String.trim/1)
  end

  import AdventOfCode2023.Day17

  # @tag :skip
  test "part1" do
    input = ~L"""
      2413432311323
      3215453535623
      3255245654254
      3446585845452
      4546657867536
      1438598798454
      4457876987766
      3637877979653
      4654967986887
      4564679986453
      1224686865563
      2546548887735
      4322674655533
      """

    assert part1(input) == 102
  end

  # @tag :skip
  test "part2" do
    input = ~L"""
      2413432311323
      3215453535623
      3255245654254
      3446585845452
      4546657867536
      1438598798454
      4457876987766
      3637877979653
      4654967986887
      4564679986453
      1224686865563
      2546548887735
      4322674655533
      """

    input2 = ~L"""
      111111111111
      999999999991
      999999999991
      999999999991
      999999999991
      """

    assert part2(input) == 94
    assert part2(input2) == 71
  end
end
