defmodule Aoc.Day02.Part2 do
  def run(stream) do
    stream
    |> Enum.join()
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

    is_chunked(num_str, half)
  end

  def is_chunked(_, 0), do: false

  def is_chunked(num, chunk) do
    if is_chunked_at(num, chunk) do
      true
    else
      is_chunked(num, chunk - 1)
    end
  end

  def is_chunked_at(num, chunk) do
    num
    |> String.graphemes()
    |> Enum.chunk_every(chunk)
    |> Enum.uniq()
    |> length() == 1
  end
end
