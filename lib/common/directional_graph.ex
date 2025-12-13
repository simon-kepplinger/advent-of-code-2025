defmodule Aoc.DirectionalGraph do
  alias Aoc.DirectionalGraph
  alias Aoc.Direction
  alias Aoc.Point
  alias Aoc.DirectionalPoint

  defstruct graph: %{}

  def new(points) do
    graph =
      points
      |> Stream.chunk_every(2, 1, [hd(points)])
      |> Stream.flat_map(fn [from, to] -> get_graph_until(from, to) end)
      |> Enum.to_list()

    %DirectionalGraph{graph: graph}
  end

  defp get_graph_until(%Point{} = from, %Point{} = to) do
    dir = Direction.get(from, to)

    build_graph(from, to, dir)
  end

  defp build_graph(%Point{} = from, %Point{} = to, _) when from == to,
    do: []

  defp build_graph(%Point{} = from, %Point{} = to, dir) do
    next = Point.neighbour(from, dir)

    [DirectionalPoint.new(from, dir) | build_graph(next, to, dir)]
  end
end
