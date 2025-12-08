defmodule Aoc.Day04.Part2 do
  alias Aoc.Point
  alias Aoc.Direction
  alias Aoc.Grid

  def run(stream) do
    grid =
      Grid.new(stream)

    initial_rolls = grid.cells |> Enum.count(&filter_rolls/1)
    grid = remove_rolls(grid)
    remaining_rolls = grid.cells |> Enum.count(&filter_rolls/1)

    initial_rolls - remaining_rolls
  end

  def remove_rolls(grid) do
    rolls = get_accessible(grid)

    if Enum.empty?(rolls) do
      grid
    else
      rolls
      |> Enum.reduce(grid, fn {point, _}, g -> Grid.set(g, {point, "."}) end)
      |> remove_rolls()
    end
  end

  def get_accessible(grid) do
    grid.cells
    |> Stream.filter(&is_accessible(&1, grid))
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

  def filter_rolls({_, val}), do: val == "@"
end
