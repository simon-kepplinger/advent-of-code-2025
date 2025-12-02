defmodule Aoc.Day01Test do
  use ExUnit.Case, async: true

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
    assert Runner.run(1, 1, @example_input) == 3
  end

  @tag :day01_part2
  test "part2 " do
    assert Runner.run(1, 2, @example_input) == 6
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

    assert Runner.run(1, 2, input) == 13
  end

  @tag :day01_part2
  test "part2 boundry 2" do
    input = """
    R100
    L100
    """

    assert Runner.run(1, 2, input) == 2
  end
end
