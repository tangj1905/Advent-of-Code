defmodule AdventOfCode2023.Day17 do
  import Record
  @moduledoc """
  Day 17 of Advent of Code 2023.
  """
  @type coord :: {i :: integer, j :: integer}
  @type grid  :: %{coord => loss :: integer, goal: coord}

  defrecordp :state, location: {0, 0}, dir: {0, 0}
  @type state :: record(
    :state, location: coord, dir: {di :: -1..1, dj :: -1..1}
  )

  @spec part1([String.t]) :: integer
  def part1(lines) do
    grid = to_grid(lines)
    init = Enum.into([
      {0, state(location: {0, 0}, dir: {0, 1})},
      {0, state(location: {0, 0}, dir: {1, 0})}
    ], Heap.min())
    dijkstra(grid, init, MapSet.new(), 1..3)
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    grid = to_grid(lines)
    init = Enum.into([
      {0, state(location: {0, 0}, dir: {0, 1})},
      {0, state(location: {0, 0}, dir: {1, 0})}
    ], Heap.min())
    dijkstra(grid, init, MapSet.new(), 4..10)
  end

  # ===== Helper functions =====
  @spec to_grid([String.t]) :: grid
  defp to_grid(lines) do
    grid = for {row, i} <- Enum.with_index(lines),
               {val, j} <- row |> String.to_charlist() |> Enum.with_index(), into: %{} do
      {{i, j}, val - ?0}
    end
    height = length(lines)
    width = byte_size(hd(lines))
    Map.put(grid, :goal, {height - 1, width - 1})
  end

  # Good 'ol Dijkstra's algorithm.
  # Our state is a record consisting of location & direction to face.
  @type memo :: %{coord => total_loss :: integer}

  @spec dijkstra(grid, Heap.t({cost :: integer, state}), MapSet.t(state), Range.t) :: integer
  defp dijkstra(grid, state_queue, visited, move_range) do
    {{cost, state = state(location: loc)}, state_queue} = Heap.split(state_queue)
    cond do
      loc == grid.goal -> cost
      state in visited -> dijkstra(grid, state_queue, visited, move_range)
      true ->
        next_states =
          state
          |> next_moves(grid, move_range)
          |> Stream.reject(fn {_acc_cost, s} -> s in visited end)
          |> Stream.map(fn {acc_cost, s} -> {cost + acc_cost, s} end)
          |> Enum.into(state_queue)

        dijkstra(grid, next_states, MapSet.put(visited, state), move_range)
    end
  end

  @spec next_moves(state, grid, Range.t) :: [{cost :: integer, state}]
  defp next_moves(state(location: {i, j}, dir: {di, dj}), grid, low..high) do
    candidates =
      1..high
      |> Stream.map(fn dist -> {i + dist * di, j + dist * dj} end)
      |> Stream.take_while(&is_map_key(grid, &1))
      |> Enum.scan({0, nil}, fn loc, {cost, _prev} ->
        {cost + grid[loc], loc}
      end)

    for {cost, pos} <- Enum.drop(candidates, low - 1), diff <- [-1, 1] do
      if di == 0 do
        {cost, state(location: pos, dir: {diff, 0})}
      else
        {cost, state(location: pos, dir: {0, diff})}
      end
    end
  end
end
