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
end
