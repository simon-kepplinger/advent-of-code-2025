defmodule Aoc.Day03.Part1 do
  def run(stream) do
    stream
    |> Stream.map(&get_hi(&1, 2))
    |> Enum.sum()
  end

  defp get_hi(line, digits) do
    size = String.length(line)

    (digits - 1)..0//-1
    |> Stream.map(&(size - &1))
    |> Stream.scan(-1, &get_hi_index(line, &2 + 1, &1))
    |> Stream.map(&String.at(line, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  defp get_hi_index(line, from, to) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.slice(from, to - from)
    |> Enum.max_by(&elem(&1, 0))
    |> elem(1)
  end
end
