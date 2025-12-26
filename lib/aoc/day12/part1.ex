defmodule Aoc.Day12.Part1 do
  def run(stream) do
    list =
      stream
      |> Enum.join("\n")
      |> String.split("\n\n")

    shapes =
      Enum.drop(list, -1)
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.reduce(
        %{},
        fn [i_str | [shape]], map ->
          i = String.to_integer(i_str)
          count = String.count(shape, "#")
          Map.put(map, i, count)
        end
      )

    regions =
      List.last(list)
      |> String.split("\n")
      |> Enum.map(fn line ->
        [dim_str | [counts_str]] = String.split(line, ":")
        [width | [height]] = String.split(dim_str, "x")

        area =
          String.to_integer(width) *
            String.to_integer(height)

        counts =
          counts_str
          |> String.trim()
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)

        {area, counts}
      end)

    regions
    |> Enum.filter(&fits?(&1, shapes))
    |> Enum.count()
  end

  def fits?({area, counts}, shapes) do
    shapes_area =
      shapes
      |> Enum.reduce(0, fn {i, count}, sum ->
        sum + count * Enum.at(counts, i)
      end)

    shapes_area <= area
  end
end
