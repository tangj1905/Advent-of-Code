defmodule AdventTester do
  use ExUnit.Case

  import AdventOfCode2023.Day01

  test "part1" do
    input = [
      "1abc2",
      "pqr3stu8vwx",
      "a1b2c3d4e5f",
      "treb7uchet"
    ]

    assert part1(input) == 142
  end

  test "part2" do
    input = [
      "eightwo",
      "fiveight"
    ]

    assert part2(input) == 140
  end
end
