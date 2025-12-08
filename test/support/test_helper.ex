defmodule Aoc.TestHelper do
  def stream_in(input \\ "") do
    input
    |> String.trim()
    |> String.split("\n")
  end
end
