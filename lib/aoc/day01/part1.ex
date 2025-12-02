defmodule Aoc.Day01.Part1 do
  def run(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> Enum.scan(50, &rem(&1 + &2, 100))
    |> Enum.filter(&(&1 == 0))
    |> Enum.count()
  end

  defp parse(<<"L", num::binary>>),
    do: -String.to_integer(num)

  defp parse(<<"R", num::binary>>),
    do: String.to_integer(num)
end
