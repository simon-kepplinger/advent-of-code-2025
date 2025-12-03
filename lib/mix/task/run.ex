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
        day2 = Aoc.Day.pad2(day)

        {time1, result1} = Aoc.Runner.run(day, 1)
        {time2, result2} = Aoc.Runner.run(day, 2)

        IO.puts("----- day #{day2} ------")
        IO.puts("----- part 1 ------\n")
        IO.inspect(result1, limit: :infinity)
        IO.puts("\n----- part 2 ------\n")
        IO.inspect(result2, limit: :infinity)

        IO.puts("\npart1 finished in #{TimeFormat.format(time1)} ...")
        IO.puts("part2 finished in #{TimeFormat.format(time2)} ...")

      [day, part] ->
        day = String.to_integer(day)
        day2 = Aoc.Day.pad2(day)
        part = String.to_integer(part)

        {time, result} = Aoc.Runner.run(day, part)

        IO.puts("----- day #{day2} ------")
        IO.puts("----- part #{part} ------\n")
        IO.inspect(result, limit: :infinity)

        IO.puts("\nfinished in #{TimeFormat.format(time)}")

      _ ->
        Mix.raise("Usage: mix aoc.run DAY [PART]")
    end
  end
end

defmodule TimeFormat do
  def format(us) when us < 1_000 do
    "#{us} µs"
  end

  def format(us) when us < 1_000_000 do
    ms = us / 1_000
    :io_lib.format("~.2f ms", [ms]) |> List.to_string()
  end

  def format(us) when us < 60_000_000 do
    s = us / 1_000_000
    :io_lib.format("~.2f s", [s]) |> List.to_string()
  end

  def format(us) do
    total_s = div(us, 1_000_000)
    mins = div(total_s, 60)
    secs = rem(total_s, 60)

    "#{mins}m #{secs}s"
  end
end
