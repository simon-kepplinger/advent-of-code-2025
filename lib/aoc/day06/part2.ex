# 10227753257075 is too low
defmodule Aoc.Day06.Part2 do
  def run(stream) do
    {nums, [ops]} =
      stream
      |> Enum.split(-1)

    ops =
      ops
      |> String.split(" ")
      |> Enum.filter(&(&1 != ""))
      |> List.to_tuple()

    width =
      nums
      |> Enum.map(&String.length/1)
      |> Enum.max()

    nums
    |> Enum.map(&String.pad_trailing(&1, width))
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.chunk_by(fn nums -> !Enum.all?(nums, &(&1 == " ")) end)
    |> Enum.take_every(2)
    |> Enum.with_index()
    |> Enum.map(fn {nums, i} -> calc_string(nums, elem(ops, i)) end)
    |> Enum.sum()
  end

  def calc_string(numbers, op) do
    numbers =
      numbers
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    calc(numbers, op)
  end

  def calc(numbers, "+"), do: Enum.reduce(numbers, &+/2)
  def calc(numbers, "*"), do: Enum.reduce(numbers, &*/2)
end
