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

  import AdventOfCode2023.Day16

  # @tag :skip
  test "part1" do
    input = ~L"""
      .|...\....
      |.-.\.....
      .....|-...
      ........|.
      ..........
      .........\
      ..../.\\..
      .-.-/..|..
      .|....-|.\
      ..//.|....
      """

    assert part1(input) == 46
  end

  @tag :skip
  test "part2" do
    input = ~L"""
      rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
      """

    assert part2(input) == 145
  end
end
