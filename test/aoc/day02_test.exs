defmodule Aoc.Day02Test do
  use ExUnit.Case, async: true

  @moduletag :day02

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
  """

  @tag :day02_part1
  test "part1" do
    {_, actual} = Runner.run(2, 1, stream_in(@example_input))

    assert actual == 1_227_775_554
  end

  @tag :day02_part2
  test "part2 " do
    {_, actual} = Runner.run(2, 2, stream_in(@example_input))

    assert actual == 4_174_379_265
  end
end
