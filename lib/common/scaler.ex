defmodule Aoc.Scaler do
  alias Aoc.DirectionalPoint
  alias Aoc.DirectionalGraph
  alias Aoc.Point

  def scale(%DirectionalGraph{graph: graph}) do
    graph =
      graph
      |> Enum.map(&scale/1)
      |> Enum.chunk_every(2, 1, [hd(graph) |> scale()])
      |> Enum.flat_map(fn [from, to] -> scale(from, to) end)

    %DirectionalGraph{
      graph: graph
    }
  end

  def scale(%DirectionalPoint{} = dir_point) do
    %DirectionalPoint{
      dir_point
      | point: Point.new(dir_point.point.x * 2, dir_point.point.y * 2)
    }
  end

  def scale(%{point: _, dir: from}, %{point: point, dir: to} = dir_point)
      when {from, to} in [
             {:left, :left},
             {:right, :right},
             {:left, :down},
             {:left, :up},
             {:down, :right}
           ] do
    [
      dir_point,
      DirectionalPoint.new(Point.neighbour(point, :right), to)
    ]
  end

  def scale(%{point: _, dir: from}, %{point: point, dir: to} = dir_point)
      when {from, to} in [
             {:up, :up},
             {:down, :down},
             {:up, :left},
             {:right, :down}
           ] do
    [
      dir_point,
      DirectionalPoint.new(Point.neighbour(point, :down), to)
    ]
  end

  def scale(%{point: _, dir: from}, %{point: point, dir: to} = dir_point)
      when {from, to} in [
             {:up, :right}
           ] do
    [
      DirectionalPoint.new(Point.neighbour(point, :right), to),
      dir_point,
      DirectionalPoint.new(Point.neighbour(point, :down), to)
    ]
  end

  def scale(_, dir_point),
    do: [dir_point]
end
