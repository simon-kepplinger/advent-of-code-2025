defmodule Aoc.Day09.Part1 do
  alias Aoc.Point

  def run(stream) do
    points =
      stream
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn [a, b] -> Point.new(a, b) end)

    points
    |> Enum.map(&max_area(&1, points))
    |> Enum.max()
  end

  def max_area(point, points) do
    points
    |> Stream.reject(&(&1 == point))
    |> Stream.map(&area(point, &1))
    |> Enum.max()
  end

  def area(
        %Point{x: x1, y: y1},
        %Point{x: x2, y: y2}
      ) do
    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end
end
