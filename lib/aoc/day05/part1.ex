defmodule Aoc.Day05.Part1 do
  def run(stream) do
    ranges =
      stream
      |> Stream.take_while(&(&1 != ""))
      |> Stream.map(&to_range/1)

    ids =
      stream
      |> Stream.drop_while(&(&1 != ""))
      |> Stream.drop(1)
      |> Stream.map(&String.to_integer/1)

    ids
    |> Enum.filter(fn id -> ranges |> Enum.any?(&(id in &1)) end)
    |> Enum.count()
  end

  defp to_range(line) do
    [from, to] =
      line
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    from..to
  end
end
