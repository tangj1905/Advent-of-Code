defmodule AdventOfCode2023.Day08 do
  @moduledoc """
  Day 8 of Advent of Code 2023.
  """

  @spec part1([String.t()]) :: integer
  def part1([dirs, "" | maps]) do
    tbl = to_table(maps)
    run_len("AAA", dirs, tbl, &(&1 == "ZZZ"))
  end

  @spec part2([String.t()]) :: integer
  def part2([dirs, "" | maps]) do
    tbl = to_table(maps)

    # We take the lowest common multiple of all path lengths...
    tbl
    |> Map.keys()
    |> Stream.filter(&String.ends_with?(&1, "A"))
    |> Stream.map(fn init ->
      run_len(init, dirs, tbl, &String.ends_with?(&1, "Z"))
    end)
    |> Enum.reduce(&lcm/2)
  end

  # ===== Helper functions =====
  @type dir_table :: %{String.t() => {String.t(), String.t()}}
  @spec to_table([String.t()]) :: dir_table
  defp to_table(maps) do
    for line <- maps, into: %{} do
      <<parent::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">> =
        line

      {parent, {left, right}}
    end
  end

  @spec run_len(String.t(), String.t(), dir_table, (String.t() -> String.t())) :: integer
  defp run_len(init, dirs, tbl, stopping_cond) do
    dirs
    |> String.to_charlist()
    |> Stream.cycle()
    |> Stream.with_index()
    |> Enum.reduce_while(init, fn {dir, dist}, cur ->
      if stopping_cond.(cur) do
        {:halt, dist}
      else
        case dir do
          ?L -> {:cont, tbl[cur] |> elem(0)}
          ?R -> {:cont, tbl[cur] |> elem(1)}
        end
      end
    end)
  end

  @spec lcm(integer, integer) :: integer
  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
