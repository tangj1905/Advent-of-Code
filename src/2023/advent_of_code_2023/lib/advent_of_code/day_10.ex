defmodule AdventOfCode2023.Day10 do
  @moduledoc """
  Day 10 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    lines
    |> to_coord_map()
    |> loop_coords()
    |> map_size()
    |> div(2)
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    height = length(lines)
    width = lines |> hd() |> byte_size()
    
    lines
    |> to_coord_map()
    |> loop_coords()
    |> count_enclosed(height, width)
  end

  # ===== Helper functions =====
  @type coord :: {x :: integer, y :: integer}
  @type coord_map :: %{coord => neighbors :: [coord], start: coord}
  @spec to_coord_map([String.t]) :: coord_map
  def to_coord_map(lines) do
    for {line, i} <- Enum.with_index(lines),
        {pipe, j} <- line |> String.to_charlist() |> Enum.with_index(),
        into: %{} do
      case pipe do
        ?| -> {{i, j}, [{i - 1, j}, {i + 1, j}]}
        ?- -> {{i, j}, [{i, j - 1}, {i, j + 1}]}
        ?L -> {{i, j}, [{i - 1, j}, {i, j + 1}]}
        ?J -> {{i, j}, [{i - 1, j}, {i, j - 1}]}
        ?7 -> {{i, j}, [{i + 1, j}, {i, j - 1}]}
        ?F -> {{i, j}, [{i + 1, j}, {i, j + 1}]}
        ?S -> {:start, {i, j}}
        ?. -> {{i, j}, []}
      end
    end
  end

  @type winding_map :: %{coord => vert_diff :: integer}
  @spec loop_coords(coord_map) :: winding_map
  def loop_coords(coord_map) do
    start = {i, j} = coord_map.start
    [_end_pos = {i1, _j1}, init_pos = {i2, _j2}] =
      [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
      |> Enum.filter(fn next -> start in Map.get(coord_map, next, []) end)

    walk_loop(coord_map, init_pos, start) |> Map.put(start, i2 - i1)
  end

  @spec walk_loop(coord_map, coord, coord) :: winding_map
  # Save the vertical differences as we traverse the loop.
  defp walk_loop(coord_map, cur_coord, prev_coord = {i1, _j1}) do
    if cur_coord == coord_map.start do
      %{}
    else
      next_coord = {i2, _j2} = Enum.find(coord_map[cur_coord], &(&1 != prev_coord))
      walk_loop(coord_map, next_coord, cur_coord) |> Map.put(cur_coord, i2 - i1)
    end
  end

  @spec count_enclosed(winding_map, integer, integer) :: integer
  defp count_enclosed(loop_windings, height, width) do
    # Taking inspiration from the winding number algorithm!
    # As we slice through each row, we track the vertical directions
    # covered by the earlier loop traversal. We know we *must* be in
    # the loop if the cumulative difference is nonzero.
    for row <- 0..(height - 1) do
      row_coords = Enum.map(0..(width - 1), fn col -> {row, col} end)

      cumulative_diffs =
        row_coords
        |> Stream.map(&Map.get(loop_windings, &1, 0))
        |> Enum.scan(&+/2)

      row_coords
      |> Stream.zip(cumulative_diffs)
      |> Enum.count(fn {coord, diff} ->
        !Map.has_key?(loop_windings, coord) && diff != 0
      end)
    end
    |> Enum.sum()
  end
end
