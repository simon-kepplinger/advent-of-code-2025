defmodule Aoc.Point do
  alias Aoc.Direction
  alias Aoc.Point

  defstruct x: 0, y: 0

  def neighbour(%Point{} = point, dir) do
    Point.add([
      point,
      dir |> Direction.as_point()
    ])
  end

  def add(points) do
    Enum.reduce(points, %Point{}, &add/2)
  end

  def add(
        %Point{x: x1, y: y1},
        %Point{x: x2, y: y2}
      ) do
    %Point{
      x: x1 + x2,
      y: y1 + y2
    }
  end
end
