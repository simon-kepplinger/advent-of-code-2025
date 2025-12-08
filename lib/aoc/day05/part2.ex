defmodule Aoc.Day05.Part2 do
  def run(stream) do
    stream
    |> Stream.take_while(&(&1 != ""))
    |> Stream.map(&to_range/1)
    |> Enum.sort_by(& &1.first)
    |> Enum.reduce([], &[trim_range(&1, &2) | &2])
    # first iteration does not catch all cases -> just run it a second time
    |> Enum.reduce([], &[trim_range(&1, &2) | &2])
    |> Enum.map(&size/1)
    |> Enum.sum()
  end

  defp to_range(line) do
    [from, to] =
      line
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    from..to
  end

  defp trim_range(nil, _), do: nil
  defp trim_range(range, []), do: range

  defp trim_range(range, [next | rest]) do
    new = trim_range(range, next)

    trim_range(new, rest)
  end

  defp trim_range(from..to//1, n_from..n_to//1)
       when n_from <= from and to <= n_to,
       do: nil

  defp trim_range(from..to//1, next) do
    from = trim_from(from, next)
    to = trim_to(to, next)

    build_range(from, to)
  end

  defp trim_from(n, from..to//1) when from <= n and n <= to, do: to + 1
  defp trim_from(n, _), do: n

  defp trim_to(n, from..to//1) when from <= n and n <= to, do: from - 1
  defp trim_to(n, _), do: n

  defp build_range(from, to) when from <= to, do: from..to
  defp build_range(_, _), do: nil

  defp size(nil), do: 0
  defp size(range), do: Range.size(range)
end
