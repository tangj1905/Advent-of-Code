defmodule AdventOfCode2023.Day04 do
  @moduledoc """
  Day 4 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    Enum.reduce(lines, 0, fn line, total ->
      case overlap_count(line) do
        0 -> total
        k -> total + 2 ** (k - 1)
      end
    end)
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    # We propagate the difference in card count and accumulate
    # as we go; this ensures an O(n) solution.
    {card_totals, _} =
      lines
      |> Stream.map(&overlap_count/1)
      |> Stream.with_index(1)
      |> Enum.map_reduce({1, %{}}, fn {win_ct, n}, {card_ct, diffs} ->
        new_diffs = Map.update(diffs, win_ct + n, -card_ct, &(&1 - card_ct))
        card_diff = card_ct + Map.get(new_diffs, n, 0)
        {card_ct, {card_ct + card_diff, new_diffs}}
      end)

    Enum.sum(card_totals)
  end

  # ===== Helper functions =====
  @spec trim_card_header(String.t) :: String.t
  defp trim_card_header(line) do
    ": " <> card_info = :string.find(line, ":")
    card_info
  end

  @spec overlap_count(String.t) :: integer
  defp overlap_count(line) do
    [winners, have] =
      line
      |> trim_card_header()
      |> String.split("|")

    winner_set =
      winners
      |> String.split(" ", trim: true)
      |> Enum.into(MapSet.new())

    have
    |> String.split(" ", trim: true)
    |> Enum.count(&(&1 in winner_set))
  end
end
