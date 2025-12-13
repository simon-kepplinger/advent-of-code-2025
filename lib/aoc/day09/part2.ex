defmodule Aoc.Day09.Part2 do
  alias Aoc.DirectionalGraph
  alias Aoc.Point

  def run(stream) do
    points =
      stream
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn [a, b] -> Point.new(a, b) end)

    areas =
      points
      |> Enum.flat_map(&with_area(&1, points))
      |> Enum.sort_by(&elem(&1, 1), :desc)
      |> Enum.map(fn {points, area} -> {normalize_rect(points), area} end)

    boundary =
      points
      |> DirectionalGraph.new()
      |> then(& &1.graph)
      |> Enum.map(fn %{point: %Point{x: x, y: y}} -> {x, y} end)
      |> MapSet.new()

    size = length(areas)

    areas
    |> Enum.chunk_every(div(size, 32))
    |> Enum.map(&ScannerServer.start({boundary, &1}))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn pid -> tap(pid, &ScannerServer.calc(&1)) end)
    |> Enum.map(&ScannerServer.get/1)
    |> Enum.filter(&(&1 != nil))
    |> Enum.max_by(fn {_, area} -> area end)
    |> elem(1)
  end

  def with_area(point, points) do
    points
    |> Enum.reject(&(&1 == point))
    |> Enum.map(&{{point, &1}, area(point, &1)})
  end

  def area(
        %Point{x: x1, y: y1},
        %Point{x: x2, y: y2}
      ) do
    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end

  def normalize_rect({%{x: x1, y: y1}, %{x: x2, y: y2}}) do
    {
      Point.new(min(x1, x2), min(y1, y2)),
      Point.new(max(x1, x2), max(y1, y2))
    }
  end
end

defmodule ScannerServer do
  use GenServer

  def start(data) do
    GenServer.start(ScannerServer, data)
  end

  def calc(pid) do
    GenServer.cast(pid, nil)
  end

  def get(pid) do
    GenServer.call(pid, nil, :infinity)
  end

  def init(data) do
    {:ok, {data, nil}}
  end

  def handle_cast(_, {{boundary, chunk}, _}) do
    res =
      chunk
      |> Enum.find(&is_within(&1, boundary))

    {:noreply, {{boundary, chunk}, res}}
  end

  def handle_call(_, _, {data, area}) do
    {:reply, area, {data, area}}
  end

  def is_within({{from, to}, _}, boundary) do
    inner_left = from.x + 1
    inner_right = to.x - 1
    inner_bottom = from.y + 1
    inner_top = to.y - 1

    x_dir = if inner_left < inner_right, do: 1, else: -1
    y_dir = if inner_bottom < inner_top, do: 1, else: -1

    rows_ok? =
      Enum.reduce_while(inner_left..inner_right//x_dir, true, fn x, _acc ->
        if MapSet.member?(boundary, {x, inner_top}) or
             MapSet.member?(boundary, {x, inner_bottom}) do
          {:halt, false}
        else
          {:cont, true}
        end
      end)

    rows_ok? and
      Enum.reduce_while(inner_bottom..inner_top//y_dir, true, fn y, _ ->
        if MapSet.member?(boundary, {inner_left, y}) or
             MapSet.member?(boundary, {inner_right, y}) do
          {:halt, false}
        else
          {:cont, true}
        end
      end)
  end
end
