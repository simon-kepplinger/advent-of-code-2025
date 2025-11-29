defmodule Mix.Tasks.Aoc.Part2 do
  use Mix.Task

  @shortdoc "Copy DayN.Part1 source to DayN.Part2: mix aoc.part2 DAY"

  @moduledoc """
  After you have a working Part 1 for a day, run:

      mix aoc.part2 1

  This copies `lib/aoc/day01/part1.ex` to `part2.ex`,
  updating the module name from `...Part1` to `...Part2`.
  """

  alias Aoc.Day

  @impl true
  def run([day_str]) do
    {day, ""} = Integer.parse(day_str)
    day2 = Day.pad2(day)

    dir = Path.join(["lib", "aoc", "day#{day2}"])
    part1 = Path.join(dir, "part1.ex")
    part2 = Path.join(dir, "part2.ex")

    unless File.exists?(part1) do
      Mix.raise("Part1 file not found: #{part1}")
    end

    IO.puts(
      "NOTE: this script will replace the contents of part2.ex for day #{day}"
    )

    IO.gets("Press ENTER to continue ...")

    content =
      part1
      |> File.read!()
      |> String.replace("Part1", "Part2")

    File.write!(part2, content)

    IO.puts("Updated Part2 from Part1 for day #{day2}.")
  end

  def run(_), do: Mix.raise("Usage: mix aoc.part2 DAY")
end
