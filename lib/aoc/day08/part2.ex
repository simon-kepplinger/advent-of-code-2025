defmodule Aoc.Day08.Part2 do
  alias Aoc.Day08.Part1

  def run(stream) do
    Part1.connect_boxes(stream, :all).last_connection
  end
end
