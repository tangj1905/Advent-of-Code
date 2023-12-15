defmodule AdventOfCode2023.Day15 do
  @moduledoc """
  Day 15 of Advent of Code 2023.
  """

  @spec part1([String.t]) :: integer
  def part1([line]) do
    line
    |> String.split(",")
    |> Stream.map(&hash_value/1)
    |> Enum.sum()
  end

  @spec part2([String.t]) :: integer
  def part2([line]) do
    boxes =
      line
      |> String.split(",")
      |> Enum.reduce(%{}, &place_lens/2)

    for {box, lenses} <- boxes,
        {{_, focal_len}, slot} <- Enum.with_index(lenses), reduce: 0 do
      total -> total + (box + 1) * (slot + 1) * focal_len
    end
  end

  # ===== Helper functions =====
  @spec hash_value(String.t) :: integer
  defp hash_value(input) do
    for <<char <- input>>, reduce: 0 do
      v -> rem((v + char) * 17, 256)
    end
  end

  # Our boxes are represented as a map associating a box number
  # with a list of lenses, represented as {label, focal_length}.

  # Some kind of order-preserving map would be more ideal, but
  # this should be ok too.
  @type lens :: {label :: String.t, focal_length :: integer}
  @type box_map :: %{box :: integer => [lens]}

  @spec place_lens(String.t, box_map) :: box_map
  defp place_lens(lens, boxes) do
    {label, lens_op} = :string.take(lens, '-=', true)
    box_id = hash_value(label)

    case lens_op do
      "-" ->
        Map.update(boxes, box_id, [], &List.keydelete(&1, label, 0))
      "=" <> focal_len ->
        lens = {label, String.to_integer(focal_len)}
        Map.update(boxes, box_id, [lens], &List.keystore(&1, label, 0, lens))
    end
  end
end
