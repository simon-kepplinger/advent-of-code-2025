defmodule Mix.Tasks.Aoc.New do
  use Mix.Task

  @shortdoc "Scaffold a aoc.new day and fetch its input: mix aoc.new DAY"

  @moduledoc """
  Generate files for a new AoC day and download its input.

      AOC_SESSION_COOKIE=... mix aoc.new 1
  """

  alias Aoc.Day

  @impl true
  def run([day_str]) do
    Mix.Task.run("app.start")

    {day, _} = Integer.parse(day_str)
    day2 = Day.pad2(day_str)

    create_day_modules(day2)
    create_test_file(day2)
    fetch_input(day)

    IO.puts("Day #{day2} created.")
  end

  def run(_), do: Mix.raise("Usage: mix aoc.new DAY")

  defp create_day_modules(day2) do
    dir = Path.join(["lib", "aoc", "day#{day2}"])
    File.mkdir_p!(dir)

    base_module = "Aoc.Day#{day2}"

    part1_path = Path.join(dir, "part1.ex")
    part2_path = Path.join(dir, "part2.ex")

    part1_content = """
    defmodule #{base_module}.Part1 do
      def run(stream) do
        stream
        |> Enum.to_list()
      end
    end
    """

    part2_content = """
    defmodule #{base_module}.Part2 do
      def run(stream) do
        stream
        |> Enum.to_list()
      end
    end
    """

    File.write!(part1_path, part1_content)
    File.write!(part2_path, part2_content)
  end

  defp create_test_file(day2) do
    test_dir = Path.join(["test", "aoc"])
    File.mkdir_p!(test_dir)

    day_int = String.to_integer(day2)
    test_path = Path.join(test_dir, "day#{day2}_test.exs")

    content = """
    defmodule Aoc.Day#{day2}Test do
      use ExUnit.Case, async: true

      @moduletag :day#{day2}

      import Aoc.TestHelper
      alias Aoc.Runner

      @example_input \"\"\"
      # put the example input from the problem statement here
      \"\"\"

      @tag :day#{day2}_part1
      test "part1" do
        {_, actual} = Runner.run(#{day_int}, 1, stream_in(@example_input)) 

        assert actual == :todo_replace_me
      end

      @tag :day#{day2}_part2
      test "part2 " do
        {_, actual} = Runner.run(#{day_int}, 2, stream_in(@example_input)) 

        assert actual == :todo_replace_me
      end
    end
    """

    File.write!(test_path, content)
  end

  defp fetch_input(day) do
    cookie =
      System.get_env("AOC_SESSION_COOKIE") ||
        Mix.raise(
          "Set AOC_SESSION_COOKIE environment variable to your Advent of Code session cookie"
        )

    url = "https://adventofcode.com/2025/day/#{day}/input"
    IO.puts("Fetching input from #{url}…")

    body = Req.get!(url, headers: [{"cookie", "session=#{cookie}"}]).body

    path = Day.in_path(day)
    File.write!(path, body)

    IO.puts("Input saved to #{path}")
  end
end
