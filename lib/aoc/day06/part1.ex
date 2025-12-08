defmodule Aoc.Day06.Part1 do
  def run(stream) do
    stream
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&calc/1)
    |> Enum.sum()
  end

  def calc([op | numbers]) do
    numbers =
      numbers
      |> Enum.map(&String.to_integer/1)

    calc(numbers, op)
  end

  def calc(numbers, "+"), do: Enum.reduce(numbers, &+/2)
  def calc(numbers, "*"), do: Enum.reduce(numbers, &*/2)
end
