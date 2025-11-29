defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  @shortdoc "Run an Advent of Code solution: mix aoc.run DAY [PART]"

  @moduledoc """
  Run a specific day/part.

      mix aoc.run 1
      mix aoc.run 1 2
  """

  @impl true
  def run(args) do
    Mix.Task.run("app.start")

    case args do
      [day] ->
        day = String.to_integer(day)
        result1 = Aoc.Runner.run(day, 1)
        result2 = Aoc.Runner.run(day, 2)

        IO.puts("\nday #{day} | part 1:\n")
        IO.inspect(result1, limit: :infinity)
        IO.puts("\nday #{day} | part 2:\n")
        IO.inspect(result2, limit: :infinity)

      [day, part] ->
        day = String.to_integer(day)
        part = String.to_integer(part)
        result = Aoc.Runner.run(day, part)

        IO.puts("\nday #{day} | part #{part}:\n")
        IO.inspect(result, limit: :infinity)

      _ ->
        Mix.raise("Usage: mix aoc.run DAY [PART]")
    end
  end
end
