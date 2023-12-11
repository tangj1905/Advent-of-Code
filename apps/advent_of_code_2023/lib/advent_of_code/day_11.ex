defmodule AdventOfCode2023.Day11 do
  @moduledoc """
  Day 11 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    lines
    |> Enum.map(&String.to_charlist/1)
    |> galaxy_positions(2)
    |> sum_dists()
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    lines
    |> Enum.map(&String.to_charlist/1)
    |> galaxy_positions(1000000)
    |> sum_dists()
  end

  # ===== Helper functions =====
  @type galaxy_map :: [[?. | ?#]]
  @type coord :: {i :: integer, j :: integer}
  @spec galaxy_positions(galaxy_map, integer) :: [coord]
  defp galaxy_positions(map, expansion_factor) do
    expand_rows = empty_rows(map)
    expand_cols = map |> Enum.zip_with(&(&1)) |> empty_rows()

    for {row, i} <- Enum.with_index(map),
        {?#, j}  <- Enum.with_index(row) do
      expanded_i = i + (expansion_factor - 1) * Enum.count(expand_rows, &(&1 < i))
      expanded_j = j + (expansion_factor - 1) * Enum.count(expand_cols, &(&1 < j))
      {expanded_i, expanded_j}
    end
  end

  @spec empty_rows(galaxy_map) :: [integer]
  defp empty_rows(map) do
    map
    |> Stream.with_index()
    |> Stream.filter(fn {row, _i} -> Enum.all?(row, &(&1 == ?.)) end)
    |> Enum.map(fn {_row, i} -> i end)
  end

  @spec dist(coord, coord) :: integer
  # Manhattan distance:
  defp dist({i1, j1}, {i2, j2}), do:
    abs(i2 - i1) + abs(j2 - j1)

  @spec sum_dists([coord]) :: integer
  defp sum_dists([]), do: 0
  defp sum_dists([coord | rest]) do
    d = rest |> Enum.map(&dist(coord, &1)) |> Enum.sum()
    d + sum_dists(rest)
  end
end
