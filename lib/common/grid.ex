defmodule Aoc.Grid do
  alias Aoc.Point
  alias Aoc.Grid

  defstruct width: 0,
            height: 0,
            cells: %{}

  def new(stream) do
    stream
    |> Enum.with_index()
    |> Enum.reduce(
      %Grid{},
      fn {row, y}, %Grid{cells: cells, height: height, width: width} ->
        {cells, row_width} = new_row(cells, row, y)

        %__MODULE__{
          cells: cells,
          height: height + 1,
          width: max(width, row_width)
        }
      end
    )
  end

  defp new_row(cells, row, y) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(
      {cells, 0},
      fn {cell, x}, {cells, row_width} ->
        cells = Map.put(cells, %Point{x: x, y: y}, cell)
        {cells, row_width + 1}
      end
    )
  end

  def set(%Grid{} = grid, {%Point{} = point, val}) do
    %Grid{grid | cells: Map.put(grid.cells, point, val)}
  end

  def is_within(grid, %Point{x: x, y: y}) do
    %__MODULE__{height: height, width: width} = grid

    x >= 0 and
      y >= 0 and
      x <= width and
      y <= height
  end
end
