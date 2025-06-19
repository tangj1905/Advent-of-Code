defmodule AdventOfCode2023.Day07 do
  @moduledoc """
  Day 7 of Advent of Code 2023.
  """

  @spec part1([String.t()]) :: integer
  def part1(lines) do
    lines
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&Hand.parse/1)
    |> Enum.sort(Hand)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {hand, i}, acc -> i * hand.wager + acc end)
  end

  @spec part2([String.t()]) :: integer
  def part2(lines) do
    lines
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&Hand.parse_jokers/1)
    |> Enum.sort(Hand)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {hand, i}, acc -> i * hand.wager + acc end)
  end
end

defmodule Hand do
  @moduledoc """
  A useful abstraction of a hand.
  """
  defstruct [:priority, :hand, wager: 0]

  @type t :: %__MODULE__{
          priority: 0..6,
          hand: [integer],
          wager: integer
        }

  @spec parse(String.t()) :: __MODULE__.t()
  def parse(<<a, b, c, d, e>> <> " " <> wager) do
    hand = Enum.map([a, b, c, d, e], &value/1)

    sorted =
      Enum.sort_by(
        hand,
        fn a ->
          {Enum.count(hand, fn b -> a == b end), a}
        end,
        :desc
      )

    init = %__MODULE__{hand: hand, wager: String.to_integer(wager)}

    # Yes, we're brute-forcing this.
    case sorted do
      [a, a, a, a, a] -> %{init | priority: 6}
      [a, a, a, a, _] -> %{init | priority: 5}
      [a, a, a, b, b] -> %{init | priority: 4}
      [a, a, a, _, _] -> %{init | priority: 3}
      [a, a, b, b, _] -> %{init | priority: 2}
      [a, a, _, _, _] -> %{init | priority: 1}
      [_, _, _, _, _] -> %{init | priority: 0}
    end
  end

  @spec parse_jokers(String.t()) :: __MODULE__.t()
  def parse_jokers(<<cards::binary-size(5)>> <> rest) do
    best_hand =
      ~c"23456789TQKA"
      |> Stream.map(&String.replace(cards, "J", <<&1>>, global: true))
      |> Stream.map(&parse(&1 <> rest))
      |> Enum.max_by(& &1, __MODULE__)

    hand =
      cards
      |> String.replace("J", "X", global: true)
      |> String.to_charlist()
      |> Enum.map(&value/1)

    %{best_hand | hand: hand}
  end

  @spec compare(__MODULE__.t(), __MODULE__.t()) :: :lt | :eq | :gt
  def compare(hand_a, hand_b) do
    %__MODULE__{priority: pa, hand: ha} = hand_a
    %__MODULE__{priority: pb, hand: hb} = hand_b

    cond do
      {pa, ha} < {pb, hb} -> :lt
      {pa, ha} > {pb, hb} -> :gt
      true -> :eq
    end
  end

  @spec value(integer) :: integer
  defp value(?A), do: 14
  defp value(?K), do: 13
  defp value(?Q), do: 12
  defp value(?J), do: 11
  defp value(?T), do: 10
  defp value(c) when c in ?2..?9, do: c - ?0
  defp value(?X), do: 1
end
