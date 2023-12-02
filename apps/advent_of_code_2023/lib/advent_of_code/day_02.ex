defmodule AdventOfCode2023.Day02 do
  @moduledoc """
  Day 2 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    for {game_id, {max_r, max_g, max_b}} <- Enum.map(lines, &parse/1),
        max_r <= 12 && max_g <= 13 && max_b <= 14, reduce: 0 do
      total -> total + game_id
    end
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    lines
    |> Stream.map(&parse/1)
    |> Stream.map(fn {_, maxes} -> Tuple.product(maxes) end)
    |> Enum.sum()
  end

  # ===== Helper functions =====
  # Parses a game description into {game #, {max_r, max_g, max_b}}:
  @type round :: {red :: integer, green :: integer, blue :: integer}
  @spec parse(String.t) :: {integer, round}
  defp parse(game_desc) do
    with "Game " <> rest     <- game_desc,
          {num, rest}        <- Integer.parse(rest),
          ": " <> round_text <- rest do
      {num, max_round(round_text)}
    end
  end

  @spec max_round(String.t) :: round
  defp max_round(round_text) do
    round_text
    |> String.split("; ")
    |> Stream.map(&parse_round/1)
    |> Enum.reduce({0, 0, 0}, fn {r, g, b}, {rr, gg, bb} ->
      {max(r, rr), max(g, gg), max(b, bb)}
    end)
  end

  @spec parse_round(String.t) :: round
  defp parse_round(text) do
    text
    |> String.split(", ")
    |> Stream.map(&Integer.parse/1)
    |> Enum.reduce({0, 0, 0}, fn
      {cnt, " red"},   {_r, g, b} -> {cnt, g, b}
      {cnt, " green"}, {r, _g, b} -> {r, cnt, b}
      {cnt, " blue"},  {r, g, _b} -> {r, g, cnt}
    end)
  end
end
