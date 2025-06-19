defmodule Mix.Tasks.Runner do
  use Mix.Task

  @shortdoc """
  Advent of Code runner
  Usage: mix runner <day> <part>
  """
  @spec run(args :: [String.t()]) :: any
  def run([day, part | _]) do
    func = fetch_function(day, part)

    input =
      File.cwd!()
      |> Path.join("inputs/input#{day}.txt")
      |> File.read!()
      |> String.trim_trailing()
      |> String.split("\r\n")
      |> Enum.map(&String.trim/1)

    {micros, output} = :timer.tc(func, [input])

    Mix.shell().info("Time: #{micros / 1000} ms")
    Mix.shell().info("Output: #{output}")
  end

  @spec fetch_function(day :: String.t(), part :: String.t()) :: function
  def fetch_function(day, part) do
    module = Module.concat([AdventOfCode2023, "Day#{day}"])
    func = String.to_atom("part#{part}")

    with {:module, _} <- Code.ensure_loaded(module),
         true <- function_exported?(module, func, 1) do
      Function.capture(module, func, 1)
    else
      {:error, _} ->
        Mix.shell().error("Module `#{inspect(module)}` is not defined.")

      false ->
        Mix.shell().error("Function `#{inspect(module)}.#{func}/1` is not defined.")
    end
  end
end
