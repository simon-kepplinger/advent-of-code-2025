defmodule Aoc.Scanner do
  alias Aoc.Point

  defstruct width: 0,
            boundary: MapSet.new([]),
            tiles: MapSet.new([])

  def new(boundary) do
    width =
      boundary
      |> Enum.max_by(& &1.x)
      |> then(& &1.x)

    %__MODULE__{
      width: width,
      boundary: boundary
    }
  end

  def all(%__MODULE__{boundary: boundary, tiles: tiles}),
    do: MapSet.union(boundary, tiles)

  def is_within(scanner, {from, to}) do
    scanner =
      scanner
      |> ray_cast(from.y..to.y)

    is_within =
      Enum.all?(scale_range(from.x..to.x), fn x ->
        Enum.all?(scale_range(from.y..to.y), fn y ->
          c = is_within(scanner, %Point{x: x, y: y})
          IO.puts("#{x}, #{y} = #{c} ")
          c
        end)
      end)

    {scanner, is_within}
  end

  def is_within(scanner, %Point{} = point) do
    MapSet.member?(scanner.tiles, point) or
      MapSet.member?(scanner.boundary, point)
  end

  def ray_cast(scanner, from..to//1) do
    scale_range(from..to)
    |> Enum.reduce(scanner, &ray_cast(&2, &1))
  end

  def ray_cast(%__MODULE__{} = scanner, y) do
    start = scanner.width + 1
    scan = %{tiles: scanner.tiles, on_boundary: false, parity: :even}

    scan =
      start..0//-1
      |> Enum.reduce(
        scan,
        &scan(&2, scanner.boundary, Point.new(&1, y))
      )

    %__MODULE__{
      scanner
      | tiles: MapSet.union(scanner.tiles, scan.tiles)
    }
  end

  defp scan(%{tiles: tiles} = scan, boundary, point) do
    case MapSet.member?(tiles, point) do
      true -> %{scan | on_boundary: false}
      false -> do_scan(scan, boundary, point)
    end
  end

  defp do_scan(
         %{tiles: tiles, on_boundary: on_boundary, parity: parity},
         boundary,
         point
       ) do
    is_boundary = MapSet.member?(boundary, point)
    parity = update_parity(is_boundary and not on_boundary, parity)

    tiles =
      if !is_boundary and parity == :odd,
        do: MapSet.put(tiles, point),
        else: tiles

    %{
      tiles: tiles,
      on_boundary: is_boundary,
      parity: parity
    }
  end

  defp update_parity(true, :even), do: :odd
  defp update_parity(true, :odd), do: :even
  defp update_parity(false, parity), do: parity

  def scale_range(from..to//1),
    do: (from * 2 + 1)..(to * 2)//2
end
