defmodule AdventOfCode2023.Day06 do
  @moduledoc """
  Day 6 of Advent of Code 2023.
  """

  @spec part1([String.t()]) :: integer
  def part1([times, distances | _]) do
    time_lst =
      times
      |> String.trim_leading("Time:")
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    distance_lst =
      distances
      |> String.trim_leading("Distance:")
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    Enum.zip_with(time_lst, distance_lst, &solve/2) |> Enum.product()
  end

  @spec part2([String.t()]) :: integer
  def part2([times, distances | _]) do
    time =
      times
      |> String.trim_leading("Time:")
      |> String.replace(" ", "", global: true)
      |> String.to_integer()

    distance =
      distances
      |> String.trim_leading("Distance:")
      |> String.replace(" ", "", global: true)
      |> String.to_integer()

    solve(time, distance)
  end

  # ===== Helper functions =====
  @spec solve(integer, integer) :: integer
  defp solve(time, dist) do
    # This is solvable via the quadratic formula.
    # distance < (time - time_held) * time_held
    # 0 < -(time_held ** 2) + time * (time_held) - distance

    # This is a quadratic expression with a = -1, b = time, c = -distance.
    # x = (-b +/- sqrt(b ** 2 - 4 * a * c)) / 2 * a
    max_time_held = ((-1 * time - :math.sqrt(time * time - 4 * dist)) / -2) |> floor()
    min_time_held = ((-1 * time + :math.sqrt(time * time - 4 * dist)) / -2) |> ceil()

    if (time - max_time_held) * max_time_held == dist do
      # Needs to be strictly greater...
      max_time_held - min_time_held - 1
    else
      max_time_held - min_time_held + 1
    end
  end
end
