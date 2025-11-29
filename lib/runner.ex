defmodule Aoc.Runner do
  @moduledoc """
  Dynamically run Advent of Code parts.

  Usage from iex:
      iex -S mix
      Aoc.Runner.run(1, 1)          # Day 1, part 1 with real input
      Aoc.Runner.run(1, 2)          # Day 1, part 2 with real input
      Aoc.Runner.run(1, 1, \"...\") # with custom input (e.g. example)
  """

  alias Aoc.Day

  @type day :: pos_integer()
  @type part :: 1 | 2

  def run(day, part, input \\ nil)

  def run(day, part, nil) when part in [1, 2] do
    input = Day.read_in(day)
    run(day, part, input)
  end

  def run(day, part, input) when part in [1, 2] and is_binary(input) do
    module = part_module(day, part)

    apply(module, :run, [input])
  end

  defp part_module(day, part) do
    day_str =
      day
      |> ensure_int()
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    Module.concat([Aoc, "Day#{day_str}", "Part#{part}"])
  end

  defp ensure_int(day) when is_integer(day), do: day
  defp ensure_int(day) when is_binary(day), do: String.to_integer(day)
end
