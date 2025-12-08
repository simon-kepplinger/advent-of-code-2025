defmodule Aoc.Day04.Part1 do
  alias Aoc.Point
  alias Aoc.Direction
  alias Aoc.Grid

  def run(stream) do
    grid = Grid.new(stream)

    grid.cells
    |> Stream.filter(&is_accessible(&1, grid))
    |> Enum.count()
  end

  def is_accessible({point, "@"}, grid) do
    rolls =
      Direction.all()
      |> Stream.map(&Point.neighbour(point, &1))
      |> Stream.map(&grid.cells[&1])
      |> Stream.filter(& &1)
      |> Stream.filter(&(&1 == "@"))
      |> Enum.count()

    rolls < 4
  end

  def is_accessible(_, _), do: false
end
