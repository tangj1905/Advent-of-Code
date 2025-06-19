defmodule AdventOfCode2023.Day14 do
  @moduledoc """
  Day 14 of Advent of Code 2023.
  """

  @spec part1([String.t()]) :: integer
  def part1(lines) do
    lines
    |> Enum.map(&String.to_charlist/1)
    |> Enum.zip_with(& &1)
    |> tilt_north()
    |> north_load()
  end

  @spec part2([String.t()]) :: integer
  def part2(lines) do
    cycle_seq =
      lines
      |> Enum.map(&String.to_charlist/1)
      |> Enum.zip_with(& &1)
      |> Stream.iterate(&cycle/1)

    {cycle_start, cycle_len} =
      cycle_seq
      |> Stream.with_index()
      |> Enum.reduce_while(%{}, fn {plat, i}, seen ->
        case Map.get(seen, plat) do
          nil -> {:cont, Map.put(seen, plat, i)}
          start -> {:halt, {start, i - start}}
        end
      end)

    pos = cycle_start + rem(1_000_000_000 - cycle_start, cycle_len)
    cycle_seq |> Enum.at(pos) |> north_load()
  end

  # ===== Helper functions =====
  @type item :: ?. | ?# | ?O
  @type platform :: [[item]]

  # It's more efficient to handle things row-wise, so we'll be working
  # with a transposed representation. This gives us the following orientation:

  # # # # # # # #
  #      W      #
  #      |      #
  # N ---+--- S #
  #      |      #
  #      E      #
  # # # # # # # #

  @spec north_load(platform) :: integer
  defp north_load(plat) do
    len = plat |> hd() |> length()

    for row <- plat, {?O, i} <- Enum.with_index(row), reduce: 0 do
      total -> total + len - i
    end
  end

  @spec tilt_north(platform) :: platform
  defp tilt_north(plat) do
    Enum.map(plat, fn col ->
      col
      |> Enum.chunk_by(&(&1 == ?#))
      |> Enum.map(&Enum.sort(&1, :desc))
      |> Enum.concat()
    end)
  end

  @spec rotate_cw(platform) :: platform
  defp rotate_cw(plat) do
    plat |> Enum.zip_with(& &1) |> Enum.reverse()
  end

  @spec cycle(platform) :: platform
  defp cycle(plat) do
    plat
    |> Stream.iterate(fn p -> p |> tilt_north() |> rotate_cw() end)
    |> Enum.at(4)
  end
end
