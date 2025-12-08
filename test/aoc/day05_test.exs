defmodule Aoc.Day05Test do
  use ExUnit.Case, async: true

  @moduletag :day05

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32  
  """

  @tag :day05_part1
  test "part1" do
    {_, actual} = Runner.run(5, 1, stream_in(@example_input))

    assert actual == 3
  end

  @tag :day05_part2
  test "part2 " do
    {_, actual} = Runner.run(5, 2, stream_in(@example_input))

    assert actual == 14
  end

  @tag :day05_part2
  test "part2 large overlaps" do
    input = """
    2-7
    3-6
    2-8
    0-2
    """

    {_, actual} = Runner.run(5, 2, stream_in(input))

    assert actual == 9
  end
end
