defmodule Aoc.Day01.Part2 do
  def run(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> Enum.flat_map(&flatten(&1, []))
    |> Enum.reduce({50, 0}, &dial/2)
    |> elem(1)
  end

  defp parse(<<"L", num::binary>>), do: -String.to_integer(num)
  defp parse(<<"R", num::binary>>), do: String.to_integer(num)

  defp flatten(n, list) when -100 < n and n < 100 do
    [n | list]
  end

  defp flatten(n, list) when n <= -100 do
    flatten(n + 100, [-100 | list])
  end

  defp flatten(n, list) when n >= 100 do
    flatten(n - 100, [100 | list])
  end

  defp dial(100, {prev, count}), do: {prev, count + 1}
  defp dial(-100, {prev, count}), do: {prev, count + 1}

  defp dial(n, {prev, count}) do
    sum = n + prev
    next = rem(sum, 100)
    rem = div(sum, 100)

    add = abs(rem) + passed_zero(prev, next)

    {next, count + min(add, 1)}
  end

  defp passed_zero(_, 0), do: 1
  defp passed_zero(from, to) when from < 0 and to > 0, do: 1
  defp passed_zero(from, to) when from > 0 and to < 0, do: 1
  defp passed_zero(_, _), do: 0
end
