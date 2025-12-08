defmodule Aoc.Day04Test do
  use ExUnit.Case, async: true

  @moduletag :day04

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  @tag :day04_part1
  test "part1" do
    {_, actual} = Runner.run(4, 1, stream_in(@example_input))

    assert actual == 13
  end

  @tag :day04_part2
  test "part2 " do
    {_, actual} = Runner.run(4, 2, stream_in(@example_input))

    assert actual == 43
  end
end
