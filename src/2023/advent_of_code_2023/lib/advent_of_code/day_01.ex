defmodule AdventOfCode2023.Day01 do
  @moduledoc """
  Day 1 of Advent of Code 2023.
  """

  @spec part1([String.t()]) :: integer
  def part1(lines) do
    lines
    |> Stream.map(&calibration_val/1)
    |> Enum.sum()
  end

  @spec part2([String.t()]) :: integer
  def part2(lines) do
    lines
    |> Stream.map(&preprocess/1)
    |> Stream.map(&calibration_val/1)
    |> Enum.sum()
  end

  # ===== Helper functions =====
  @conversion [
    {"one", "1"},
    {"two", "2"},
    {"three", "3"},
    {"four", "4"},
    {"five", "5"},
    {"six", "6"},
    {"seven", "7"},
    {"eight", "8"},
    {"nine", "9"}
  ]

  @spec calibration_val(String.t()) :: integer
  defp calibration_val(line) do
    digits = for <<digit::utf8 <- line>>, digit in ?0..?9, do: digit - ?0
    10 * List.first(digits) + List.last(digits)
  end

  @spec preprocess(String.t()) :: String.t()
  defp preprocess(""), do: ""

  defp preprocess(<<ch, rest::binary>> = line) do
    {_, replace} =
      Enum.find(@conversion, {nil, <<ch>>}, fn {str, _digit} ->
        String.starts_with?(line, str)
      end)

    replace <> preprocess(rest)
  end
end
