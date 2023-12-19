defmodule AdventOfCode2023.Day18 do
  @moduledoc """
  Day 18 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    dir_map = %{
      "U" => {-1, 0}, "L" => {0, -1}, "D" => {1, 0}, "R" => {0, 1}
    }

    points = Enum.scan(lines, {0, 0}, fn line, {i, j} ->
      [dir, dist, _] = String.split(line)
      distance = String.to_integer(dist)
      {di, dj} = dir_map[dir]
      {i + distance * di, j + distance * dj}
    end)

    count_enclosed([{0, 0} | points])
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    dir_map = %{
      "3" => {-1, 0}, "2" => {0, -1}, "1" => {1, 0}, "0" => {0, 1}
    }

    points = Enum.scan(lines, {0, 0}, fn line, {i, j} ->
      [_, _, <<"(#", dist :: binary-size(5), dir :: binary-size(1), ")">>] = String.split(line)
      distance = String.to_integer(dist, 16)
      {di, dj} = dir_map[dir]
      {i + distance * di, j + distance * dj}
    end)

    count_enclosed([{0, 0} | points])
  end

  # ===== Helper functions =====
  @type coord :: {i :: integer, j :: integer}

  # Using Pick's theorem! Area can be calculated via the shoelace formula.
  # total_points = area + boundary_points / 2 + 1
  @spec count_enclosed([coord]) :: integer
  defp count_enclosed(points) do
    pairwise = Enum.chunk_every(points, 2, 1, :discard)

    area =
      pairwise
      |> Stream.map(fn [{x1, y1}, {x2, y2}] -> x1 * y2 - x2 * y1 end)
      |> Enum.sum()
      |> div(2)

    boundary_points =
      pairwise
      |> Stream.map(fn [{x1, y1}, {x2, y2}] -> abs(x2 - x1) + abs(y2 - y1) end)
      |> Enum.sum()

    abs(area) + div(boundary_points, 2) + 1
  end
end
