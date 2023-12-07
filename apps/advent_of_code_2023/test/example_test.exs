defmodule AdventTester do
  use ExUnit.Case

  # A convenience sigil to convert a multiline
  # heredoc to a list of lines:
  defp sigil_l(str, []), do:
    str |> String.split("\r\n") |> Enum.map(&String.trim/1)

  import AdventOfCode2023.Day07

  # @tag :skip
  test "part1" do
    input = ~l"""
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
      """

    assert part1(input) == 6440
  end

  # @tag :skip
  test "part2" do
    input = ~l"""
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
      """

    assert part2(input) == 5905
  end
end
