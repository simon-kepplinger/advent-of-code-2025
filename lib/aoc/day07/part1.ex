defmodule Aoc.Day07.Part1 do
  alias Aoc.Grid

  def run(stream) do
    manifold = Grid.new(stream)
    {start, _} = Grid.find(manifold, "S")

    manifold
    |> Grid.get(start, :down)
    |> then(&star_move(manifold, &1))
    |> Enum.count()
  end

  def star_move(manifold, start) do
    {splitters, _cache} = move(manifold, start, %{})

    splitters
  end

  # bottom reached
  defp move(_, {_, nil}, cache),
    do: {MapSet.new(), cache}

  # cache hit
  defp move(_, {pos, _}, cache) when is_map_key(cache, pos),
    do: {cache[pos], cache}

  # simple move down
  defp move(manifold, {pos, "."}, cache) do
    next = manifold |> Grid.get(pos, :down)

    {splitters, cache} =
      manifold
      |> move(next, cache)

    {splitters, Map.put(cache, pos, splitters)}
  end

  # splitter reached 
  defp move(manifold, {pos, "^"}, cache) do
    left = manifold |> Grid.get(pos, :left)
    right = manifold |> Grid.get(pos, :right)

    {left_set, cache} = manifold |> move(left, cache)
    {right_set, cache} = manifold |> move(right, cache)

    # move left and right + add current pos to splitters
    splitters =
      MapSet.union(left_set, right_set)
      |> MapSet.put(pos)

    {splitters, Map.put(cache, pos, splitters)}
  end
end
