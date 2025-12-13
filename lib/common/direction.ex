defmodule Aoc.Direction do
  alias Aoc.Point

  @type direction ::
          :up
          | :up_right
          | :right
          | :down_right
          | :down
          | :down_left
          | :left
          | :up_left

  def all do
    [
      :up,
      :up_right,
      :right,
      :down_right,
      :down,
      :down_left,
      :left,
      :up_left
    ]
  end

  def cardinal do
    [
      :up,
      :right,
      :down,
      :left
    ]
  end

  def as_point(:up), do: %Point{x: 0, y: -1}
  def as_point(:right), do: %Point{x: 1, y: 0}
  def as_point(:down), do: %Point{x: 0, y: 1}
  def as_point(:left), do: %Point{x: -1, y: 0}
  def as_point(:up_right), do: %Point{x: 1, y: -1}
  def as_point(:up_left), do: %Point{x: -1, y: -1}
  def as_point(:down_right), do: %Point{x: 1, y: 1}
  def as_point(:down_left), do: %Point{x: -1, y: 1}

  def get(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}) do
    dx = x2 - x1
    dy = y2 - y1

    get(sign(dx), sign(dy))
  end

  def get(0, -1), do: :up
  def get(1, 0), do: :right
  def get(0, 1), do: :down
  def get(-1, 0), do: :left
  def get(1, -1), do: :up_right
  def get(-1, -1), do: :up_left
  def get(1, 1), do: :down_right
  def get(-1, 1), do: :down_left
  def get(0, 0), do: :error
  def get(_, _), do: :error

  defp sign(0), do: 0
  defp sign(n) when n > 0, do: 1
  defp sign(_), do: -1
end
