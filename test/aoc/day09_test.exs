defmodule Aoc.Day09Test do
  use ExUnit.Case, async: true

  @moduletag :day09

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """

  @tag :day09_part1
  test "part1" do
    {_, actual} = Runner.run(9, 1, stream_in(@example_input))

    assert actual == 50
  end

  @tag :day09_part2
  test "part2 " do
    {_, actual} = Runner.run(9, 2, stream_in(@example_input))

    assert actual == 24
  end
end
