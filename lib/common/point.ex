defmodule Aoc.Point do
  alias Aoc.Direction
  alias Aoc.Point

  defstruct x: 0, y: 0

  def new(x, y) when is_integer(x) and is_integer(y) do
    %__MODULE__{x: x, y: y}
  end

  def new(x, y) when is_binary(x) and is_binary(y) do
    %__MODULE__{
      x: String.to_integer(x),
      y: String.to_integer(y)
    }
  end

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

  def distance(
        %__MODULE__{x: x1, y: y1},
        %__MODULE__{x: x2, y: y2}
      ) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end
end

defmodule Aoc.DirectionalPoint do
  alias Aoc.Point
  alias Aoc.Direction

  defstruct point: Point.new(0, 0),
            dir: :up

  def new(%Point{} = point, %Point{} = other) do
    dir = Direction.get(point, other)

    new(point, dir)
  end

  def new(%Point{} = point, dir) do
    %__MODULE__{point: point, dir: dir}
  end
end
