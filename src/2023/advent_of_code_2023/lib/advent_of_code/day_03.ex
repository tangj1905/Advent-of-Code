defmodule AdventOfCode2023.Day03 do
  @moduledoc """
  Day 3 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    for nums <- lines |> parts_by_symbol() |> Map.values(),
        reduce: 0 do
      sum -> sum + Enum.sum(nums)
    end
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    for [a, b] <- lines |> parts_by_symbol() |> Map.values(),
        reduce: 0 do
      sum -> sum + a * b
    end
  end

  # ===== Helper functions =====
  @type point :: {i :: integer, j :: integer}
  @spec symbol_positions([String.t]) :: MapSet.t(point)
  defp symbol_positions(grid) do
    for {row, i} <- Enum.with_index(grid),
        {chr, j} <- row |> String.to_charlist() |> Enum.with_index(),
        chr not in '0123456789.', into: MapSet.new() do
      {i, j}
    end
  end

  @spec get_adjacent(integer, integer, integer) :: [point]
  defp get_adjacent(i, j, len) do
    above = Enum.map(j - 1..j + len, &{i - 1, &1})
    below = Enum.map(j - 1..j + len, &{i + 1, &1})
    [{i, j - 1}, {i, j + len} | above ++ below]
  end

  @spec parts_by_symbol([String.t]) :: %{point => [integer]}
  defp parts_by_symbol(grid) do
    symbol_pts = symbol_positions(grid)

    for {str, i}   <- Enum.with_index(grid),
        [{j, len}] <- Regex.scan(~r/[[:digit:]]+/, str, return: :index),
        adjacent   <- get_adjacent(i, j, len), adjacent in symbol_pts do
      num = str |> :binary.part(j, len) |> String.to_integer()
      {adjacent, num}
    end
    |> Enum.group_by(fn {pt, _num} -> pt end, fn {_pt, num} -> num end)
  end
end
