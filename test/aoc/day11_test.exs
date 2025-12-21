defmodule Aoc.Day11Test do
  use ExUnit.Case, async: true

  @moduletag :day11

  import Aoc.TestHelper
  alias Aoc.Runner

  @example_input """
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
  """

  @example_input2 """
  svr: aaa bbb
  aaa: fft
  fft: ccc
  bbb: tty
  tty: ccc
  ccc: ddd eee
  ddd: hub
  hub: fff
  eee: dac
  dac: fff
  fff: ggg hhh
  ggg: out
  hhh: out
  """

  @tag :day11_part1
  test "part1" do
    {_, actual} = Runner.run(11, 1, stream_in(@example_input))

    assert actual == 5
  end

  @tag :day11_part2
  test "part2 " do
    {_, actual} = Runner.run(11, 2, stream_in(@example_input2))

    assert actual == 2
  end
end
