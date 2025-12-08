defmodule Aoc.Day06Test do
  use ExUnit.Case, async: true

  @moduletag :day06

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  123 328  51 64 
   45 64  387 23 
    6 98  215 314
  *   +   *   +  
  """

  @tag :day06_part1
  test "part1" do
    {_, actual} = Runner.run(6, 1, stream_in(@example_input))

    assert actual == 4_277_556
  end

  @tag :day06_part2
  test "part2 " do
    {_, actual} = Runner.run(6, 2, stream_in(@example_input))

    assert actual == 3_263_827
  end
end
