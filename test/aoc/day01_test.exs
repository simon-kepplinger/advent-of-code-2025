defmodule Aoc.Day01Test do
  use ExUnit.Case, async: true

  import Aoc.TestHelper
  alias Aoc.Runner

  @moduletag :day01

  @example_input """
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  @tag :day01_part1
  test "part1" do
    {_, actual} = Runner.run(1, 1, stream_in(@example_input))

    assert actual == 3
  end

  @tag :day01_part2
  test "part2 " do
    {_, actual} = Runner.run(1, 2, stream_in(@example_input))

    assert actual == 6
  end

  @tag :day01_part2
  test "part2 boundry 1" do
    input = """
    L168
    R100
    L30
    R248
    L5
    R60
    L55
    L1
    L99
    R214
    L182
    """

    {_, actual} = Runner.run(1, 2, stream_in(input))

    assert actual == 13
  end

  @tag :day01_part2
  test "part2 boundry 2" do
    input = """
    R100
    L100
    """

    {_, actual} = Runner.run(1, 2, stream_in(input))

    assert actual == 2
  end
end
