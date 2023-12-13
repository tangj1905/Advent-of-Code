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

  import AdventOfCode2023.Day12

  # @tag :skip
  test "part1" do
    input = ~l"""
      ???.### 1,1,3
      .??..??...?##. 1,1,3
      ?#?#?#?#?#?#?#? 1,3,1,6
      ????.#...#... 4,1,1
      ????.######..#####. 1,6,5
      ?###???????? 3,2,1
      """

    assert part1(input) == 21
  end

  # @tag :skip
  test "part2" do
    input = ~l"""
      ???.### 1,1,3
      .??..??...?##. 1,1,3
      ?#?#?#?#?#?#?#? 1,3,1,6
      ????.#...#... 4,1,1
      ????.######..#####. 1,6,5
      ?###???????? 3,2,1
      """

    assert part2(input) == 525152
  end
end
