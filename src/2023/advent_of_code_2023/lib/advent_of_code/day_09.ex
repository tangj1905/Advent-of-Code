defmodule AdventOfCode2023.Day09 do
  @moduledoc """
  Day 9 of Advent of Code 2023.
  """

  @spec part1([String.t()]) :: integer
  def part1(lines) do
    lines
    |> Stream.map(&parse_line/1)
    |> Stream.map(&Enum.reverse/1)
    |> Stream.map(&extrapolate/1)
    |> Enum.sum()
  end

  @spec part2([String.t()]) :: integer
  def part2(lines) do
    lines
    |> Stream.map(&parse_line/1)
    |> Stream.map(&extrapolate/1)
    |> Enum.sum()
  end

  # ===== Helper functions =====
  @spec parse_line(String.t()) :: [integer]
  defp parse_line(line) do
    line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  @spec extrapolate([integer]) :: integer
  defp extrapolate([h | tl] = seq) do
    if Enum.all?(seq, &(&1 == 0)) do
      0
    else
      sub_diff = Enum.zip_with(seq, tl, &-/2) |> extrapolate()
      h + sub_diff
    end
  end
end
