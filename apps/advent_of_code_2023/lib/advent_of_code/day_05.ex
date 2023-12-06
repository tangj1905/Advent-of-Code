defmodule AdventOfCode2023.Day05 do
  @moduledoc """
  Day 5 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    ["seeds: " <> seeds | maps] = lines

    # This will turn each map into a function that
    # maps a range into a list of subsequent ranges.
    mapping_fn =
      maps
      |> parse_mappings()
      |> Stream.map(&map_to_range_fn/1)
      |> Enum.reduce(&[&1], fn g, f ->
        &(&1 |> f.() |> Enum.flat_map(g))
      end)

    seeds
    |> String.split(" ", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.flat_map(fn i -> mapping_fn.(i..i) end)
    |> Stream.map(&(&1.first))
    |> Enum.min()
  end

  @spec part2([String.t]) :: integer
  # Applied range optimization - this takes < 1s to execute.
  def part2(lines) do
    ["seeds: " <> seeds | maps] = lines

    mapping_fn =
      maps
      |> parse_mappings()
      |> Stream.map(&map_to_range_fn/1)
      |> Enum.reduce(&[&1], fn g, f ->
        &(&1 |> f.() |> Enum.flat_map(g))
      end)

    seeds
    |> String.split(" ", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Stream.flat_map(fn [from, len] -> mapping_fn.(from..(from + len - 1)) end)
    |> Stream.map(&(&1.first))
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

  @spec map_to_range_fn([[integer]]) :: (Range.t -> [Range.t])
  defp map_to_range_fn(mapping) do
    Enum.reduce(mapping, &[&1], fn [dest, src, len], f ->
      fn l..r ->
        l_range = l..min(r, src - 1)//1
        m_range = max(l, src)..min(r, src + len - 1)//1 |> Range.shift(dest - src)
        r_range = max(l, src + len)..r//1

        still_requires_mapping =
          [l_range, r_range]
          |> Enum.reject(&Enum.empty?/1)
          |> Enum.flat_map(f)

        Enum.reject([m_range | still_requires_mapping], &Enum.empty?/1)
      end
    end)
  end
end
