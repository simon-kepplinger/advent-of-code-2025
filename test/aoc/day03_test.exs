defmodule Aoc.Day03Test do
  use ExUnit.Case, async: true

  @moduletag :day03

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  @tag :day03_part1
  test "part1" do
    {_, actual} = Runner.run(3, 1, stream_in(@example_input))

    assert actual == 357
  end

  @tag :day03_part2
  test "part2 " do
    {_, actual} = Runner.run(3, 2, stream_in(@example_input))

    assert actual == 3_121_910_778_619
  end
end
