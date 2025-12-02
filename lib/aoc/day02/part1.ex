defmodule Aoc.Day02.Part1 do
  def run(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&to_range/1)
    |> Enum.flat_map(&extract_invalid/1)
    |> Enum.sum()
  end

  def to_range(range_str) do
    range_str
    |> String.split("-", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [from, to] -> from..to end)
  end

  def extract_invalid(range) do
    range
    |> Stream.filter(&is_invalid/1)
  end

  def is_invalid(num) do
    num_str = Integer.to_string(num)
    half = div(String.length(num_str), 2)

    {a, b} = String.split_at(num_str, half)

    a == b
  end
end
