defmodule AdventOfCode2023.Day12 do
  import Record
  @moduledoc """
  Day 12 of Advent of Code 2023.
  """
  defrecordp :state, springs: "", chunks: []
  @type dp_state :: record(:state, springs: [?. | ?? | ?#], chunks: [integer])

  @spec part1([String.t]) :: integer
  def part1(lines) do
    for line <- lines do
      [springs, chunks] = String.split(line)
      dp(%{}, to_state(springs, chunks)) |> elem(0)
    end
    |> Enum.sum()
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    for line <- lines do
      [springs, chunks] = String.split(line)
      dup_springs = springs |> List.duplicate(5) |> Enum.join("?")
      dup_chunks  = chunks  |> List.duplicate(5) |> Enum.join(",")
      dp(%{}, to_state(dup_springs, dup_chunks)) |> elem(0)
    end
    |> Enum.sum()
  end

  # ===== Helper functions =====
  @type memo :: %{dp_state => integer}
  @spec dp(memo, dp_state) :: {integer, memo}
  defp dp(memo, state) when is_map_key(memo, state), do:
    {memo[state], memo}

  # Base conditions:
  defp dp(memo, state = state(springs: [], chunks: [])), do:
    {1, Map.put(memo, state, 1)}
  defp dp(memo, state = state(springs: [], chunks: _chunks)), do:
    {0, Map.put(memo, state, 0)}
  defp dp(memo, state = state(springs: sprs, chunks: [])) do
    ways = if Enum.all?(sprs, &(&1 != ?#)), do: 1, else: 0
    {ways, Map.put(memo, state, ways)}
  end

  # Three main cases:
  # Case 1: if we encounter an operational spring, skip it and continue.
  # Case 2: if we encounter a defective spring, we must try to build the next chunk around it.
  # Case 3: otherwise, try both.
  defp dp(memo, state = state(springs: [spr | _])) do
    {ways, memo_new} = case spr do
      ?. -> skip_one(memo, state)
      ?# -> accept_chunk(memo, state)
      ?? ->
        {ways_skip, memo_1} = skip_one(memo, state)
        {ways_accept, memo_2} = accept_chunk(memo_1, state)
        {ways_skip + ways_accept, memo_2}
    end
    {ways, Map.put(memo_new, state, ways)}
  end

  @spec skip_one(memo, dp_state) :: {integer, memo}
  defp skip_one(memo, state = state(springs: [_ | sprs])) do
    dp(memo, state(state, springs: sprs))
  end

  @spec accept_chunk(memo, dp_state) :: {integer, memo}
  defp accept_chunk(memo, state(springs: sprs, chunks: [chk | chks])) do
    with {spring_chunk, rest} <- Enum.split(sprs, chk),
         true <- length(spring_chunk) == chk && Enum.all?(spring_chunk, &(&1 != ?.)),
         false <- match?([?# | _], rest) do
      dp(memo, state(springs: Enum.drop(rest, 1), chunks: chks))
    else
      _ -> {0, memo}
    end
  end

  @spec to_state(String.t, String.t) :: dp_state
  defp to_state(springs, chunks) do
    springs = String.to_charlist(springs)
    chunks = chunks |> String.split(",") |> Enum.map(&String.to_integer/1)
    state(springs: springs, chunks: chunks)
  end
end
