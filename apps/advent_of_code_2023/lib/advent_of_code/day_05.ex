defmodule AdventOfCode2023.Day05 do
  @moduledoc """
  Day 4 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    ["seeds: " <> seeds | maps] = lines

    # This will turn each map into a function,
    # where we will compose them together:
    mapping_fn =
      maps
      |> parse_mappings()
      |> Stream.map(&map_to_fn/1)
      |> Enum.reduce(fn g, f -> &g.(f.(&1)) end)

    seeds
    |> String.split(" ", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(mapping_fn)
    |> Enum.min()
  end

  @spec part2([String.t]) :: integer
  # Brute force, but in parallel!
  def part2(lines) do
    ["seeds: " <> seeds | maps] = lines

    mapping_fn =
      maps
      |> parse_mappings()
      |> Stream.map(&map_to_fn/1)
      |> Enum.reduce(fn g, f -> &g.(f.(&1)) end)

    seed_ranges =
      seeds
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [from, len] -> from..(from + len - 1) end)

    seed_ranges
    |> Stream.map(&Task.async(fn -> Enum.reduce(&1, :inf,
      fn i, acc -> min(mapping_fn.(i), acc) end)
    end))
    |> Stream.map(&Task.await(&1, :infinity))
    |> Enum.min()
  end

  # ===== Helper functions =====
  @spec parse_mappings([String.t]) :: [[integer]]
  defp parse_mappings(maps) do
    is_header_line =
      fn line -> String.ends_with?(line, "map:") end

    chunks =
      maps
      |> Stream.reject(&(&1 == ""))
      |> Stream.chunk_by(is_header_line)
      |> Enum.reject(fn [header | _] -> is_header_line.(header) end)

    for mapping_chunk <- chunks do
      mapping_chunk
      |> Stream.map(&String.split(&1, " "))
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
    end
  end

  @spec map_to_fn([[integer]]) :: (integer -> integer)
  defp map_to_fn(mapping) do
    Enum.reduce(mapping, &Function.identity/1, fn [dest, src, len], f ->
      fn
        n when src <= n and n < src + len -> dest + n - src
        n -> f.(n)
      end
    end)
  end
end
