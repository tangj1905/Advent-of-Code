defmodule AdventOfCode2023.Day16 do
  @moduledoc """
  Day 16 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1(lines) do
    grid = to_grid(lines)
    init = {{0, 0}, {0, 1}}

    count_tiles(grid, init)
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    grid = to_grid(lines)
    l = length(lines)
    w = lines |> hd() |> byte_size()

    horiz = Enum.flat_map(0..l - 1, fn i -> [{{i, 0}, {0, 1}}, {{i, w - 1}, {0, -1}}] end)
    verti = Enum.flat_map(0..w - 1, fn j -> [{{0, j}, {1, 0}}, {{l - 1, j}, {-1, 0}}] end)

    (horiz ++ verti)
    |> Enum.map(&Task.async(fn -> count_tiles(grid, &1) end))
    |> Task.await_many(:infinity)
    |> Enum.max()
  end

  # ===== Helper functions =====
  @type element :: ?. | ?/ | ?\\ | ?- | ?|
  @type coord   :: {i :: integer, j :: integer}
  @type grid    :: %{coord => element}

  @spec to_grid([String.t]) :: grid
  defp to_grid(lines) do
    for {row, i} <- Enum.with_index(lines),
        {elt, j} <- row |> String.to_charlist() |> Enum.with_index(), into: %{} do
      {{i, j}, elt}
    end
  end

  # Each beam has a coordinate and a direction!
  @type beam :: {coord, direction :: {di :: -1..1, dj :: -1..1}}

  @spec propagate(grid, beam) :: [beam]
  defp propagate(grid, {{i, j} = coord, {di, dj} = dir}) do
    neighbors = case grid[coord] do
      nil -> []

      # Reflecting:
      ?/  -> [{{i - dj, j - di}, {-dj, -di}}]
      ?\\ -> [{{i + dj, j + di}, { dj,  di}}]

      # Splitting:
      ?| when di == 0 -> [{{i + 1, j}, {1, 0}}, {{i - 1, j}, {-1, 0}}]
      ?- when dj == 0 -> [{{i, j + 1}, {0, 1}}, {{i, j - 1}, {0, -1}}]

      # Continuing:
      _ -> [{{i + di, j + dj}, dir}]
    end
    Enum.filter(neighbors, fn {coord, _dir} -> is_map_key(grid, coord) end)
  end

  @spec count_tiles(grid, beam) :: integer
  defp count_tiles(grid, init) do
    vis_set = bfs([init], grid, MapSet.new([init]))

    vis_set
    |> Enum.uniq_by(fn {coord, _dir} -> coord end)
    |> length()
  end

  @spec bfs(frontier :: [beam], grid, visited :: MapSet.t(beam)) :: MapSet.t(beam)
  defp bfs([], _grid, vis), do: vis
  defp bfs(frontier, grid, vis) do
    next =
      frontier
      |> Stream.flat_map(fn beam -> propagate(grid, beam) end)
      |> Enum.reject(&(&1 in vis))

    bfs(next, grid, Enum.into(next, vis))
  end
end
