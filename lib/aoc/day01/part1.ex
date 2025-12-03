defmodule Aoc.Day01.Part1 do
  def run(stream) do
    stream
    |> Enum.to_list()
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
