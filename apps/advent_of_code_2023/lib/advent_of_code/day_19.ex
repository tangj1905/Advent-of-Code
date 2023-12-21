defmodule AdventOfCode2023.Day19 do
  @moduledoc """
  Day 19 of Advent of Code 2023.
  """
  defmodule PartRange do
    # A helper struct to represent part ranges!
    defstruct x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000
    @type t :: %PartRange{x: Range.t, m: Range.t, a: Range.t, s: Range.t}

    @spec empty?(PartRange.t) :: boolean
    def empty?(%PartRange{x: x, m: m, a: a, s: s}) do
      Enum.any?([x, m, a, s], &Enum.empty?/1)
    end
  end

  @spec part1([String.t]) :: integer
  def part1(lines) do
    {rules, ["" | parts]} = Enum.split_while(lines, &(&1 != ""))
    rule_map = parse_rules(rules)
    part_list = Enum.map(parts, fn part ->
      [x, m, a, s] =
        part
        |> String.split(["{", ",", "}", "x=", "m=", "a=", "s="], trim: true)
        |> Enum.map(&String.to_integer/1)

      %PartRange{x: x..x, m: m..m, a: a..a, s: s..s}
    end)

    for part <- part_list,
        valid_part <- valid_parts(part, rule_map["in"], rule_map), reduce: 0 do
      total ->
        %PartRange{x: x, m: m, a: a, s: s} = valid_part
        ratings = [x, m, a, s] |> Enum.map(&(&1.first)) |> Enum.sum()
        total + ratings
    end
  end

  @spec part2([String.t]) :: integer
  def part2(lines) do
    rule_map = lines |> Enum.take_while(&(&1 != "")) |> parse_rules()

    for valid_range <- valid_parts(%PartRange{}, rule_map["in"], rule_map), reduce: 0 do
      total ->
        %PartRange{x: x, m: m, a: a, s: s} = valid_range
        perms = [x, m, a, s] |> Enum.map(&Range.size/1) |> Enum.product()
        total + perms
    end
  end

  # ===== Helper functions =====
  @type attrib :: :x | :m  | :a | :s
  @type op     :: :< | :>
  @type action :: {op, attrib, threshold :: integer, dest_rule :: String.t}

  @type rule_map :: %{rule_name :: String.t => [action]}
  @spec parse_rules([String.t]) :: rule_map
  defp parse_rules(rules) do
    for rule <- rules, into: %{} do
      [rule_name | stmts] = String.split(rule, ["{", ",", "}"], trim: true)
      {rule_name, Enum.map(stmts, &parse_rule_stmt/1)}
    end
  end

  @spec parse_rule_stmt(String.t) :: action
  defp parse_rule_stmt(stmt) do
    case Regex.split(~r/[<:>]/, stmt, include_captures: true) do
      [attrib, op, thresh, ":", dest] ->
        {String.to_existing_atom(op), String.to_existing_atom(attrib), String.to_integer(thresh), dest}
      [else_dest] -> # Just use a dummy action here:
        {:<, :x, 1_000_000, else_dest}
    end
  end

  # We can just perform a depth-first search to extract
  # all of the part ranges that satisfy a part.
  # Mostly redundant for part 1, but extremely useful for part 2.
  @spec valid_parts(range :: PartRange.t, [action], rule_map) :: [PartRange.t]
  defp valid_parts(_part_range, [], _rule_map), do: []
  defp valid_parts(part_range, [action = {_op, _attr, _thresh, dest} | rest], rule_map) do
    {pass, fail} = do_action(part_range, action)
    cond do
      # Break conditions - abort completely or move on:
      PartRange.empty?(part_range) -> []
      PartRange.empty?(pass)       -> valid_parts(fail, rest, rule_map)

      # Special destination rules:
      dest == "A" -> [pass | valid_parts(fail, rest, rule_map)]
      dest == "R" -> valid_parts(fail, rest, rule_map)

      # Nominal case:
      true -> valid_parts(pass, rule_map[dest], rule_map) ++ valid_parts(fail, rest, rule_map)
    end
  end

  @spec do_action(range :: PartRange.t, action) :: {pass :: PartRange.t, fail :: PartRange.t}
  defp do_action(range, {op, attrib, threshold, _dest}) do
    l..r = Map.get(range, attrib)
    case op do
      :< ->
        {Map.replace(range, attrib, l..min(r, threshold - 1)//1),
         Map.replace(range, attrib, max(l, threshold)..r//1)}
      :> ->
        {Map.replace(range, attrib, max(l, threshold + 1)..r//1),
         Map.replace(range, attrib, l..min(r, threshold)//1)}
    end
  end
end
