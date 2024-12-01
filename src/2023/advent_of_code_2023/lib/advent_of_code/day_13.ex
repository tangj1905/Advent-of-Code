defmodule AdventOfCode2023.Day13 do
  @moduledoc """
  Day 13 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    lines
    |> parse_patterns()
    |> Stream.map(&symmetry_value/1)
    |> Enum.sum()
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    lines
    |> parse_patterns()
    |> Stream.map(&symmetry_value(&1, 1))
    |> Enum.sum()
  end

  # ===== Helper functions =====
  @type pattern :: [[?# | ?.]]
  @spec symmetry_value(pattern, smudge_factor :: integer) :: integer
  defp symmetry_value([p | ps] = pattern, smudge_factor \\ 0) do
    [r | rs] = Enum.zip_with(pattern, &(&1))
    find_axis(rs, [r], 1, smudge_factor) || 100 * find_axis(ps, [p], 1, smudge_factor)
  end

  @spec find_axis(pattern, pattern, idx :: integer, smudge_factor :: integer) :: integer | nil
  defp find_axis([], _rev_pattern, _idx, _smudge_factor), do: nil
  defp find_axis([p | rest] = pattern, rev_pattern, idx, smudge_factor) do
    if smudge_count(pattern, rev_pattern) == smudge_factor do
      idx
    else
      find_axis(rest, [p | rev_pattern], idx + 1, smudge_factor)
    end
  end

  @spec smudge_count(pattern, pattern) :: integer
  defp smudge_count(pattern, rev_pattern) do
    for {row_a, row_b} <- Enum.zip(pattern, rev_pattern), reduce: 0 do
      diffs ->
        ds = Enum.zip_with(row_a, row_b, &!=/2) |> Enum.count(&(&1))
        diffs + ds
    end
  end

  @spec parse_patterns([String.t]) :: [pattern]
  defp parse_patterns(lines) do
    lines
    |> Stream.map(&String.to_charlist/1)
    |> Stream.chunk_by(&Enum.empty?/1)
    |> Enum.reject(fn divider -> divider == [[]] end)
  end
end
