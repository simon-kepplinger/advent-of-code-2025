defmodule Aoc.Day07.Part2 do
  alias Aoc.Grid

  def run(stream) do
    manifold = Grid.new(stream)
    {start, _} = Grid.find(manifold, "S")

    manifold
    |> Grid.get(start, :down)
    |> then(&star_move(manifold, &1))
  end

  def star_move(manifold, start) do
    {count, _cache} = move(manifold, start, %{})

    count + 1
  end

  # bottom reached
  defp move(_, {_, nil}, cache),
    do: {0, cache}

  # cache hit
  defp move(_, {pos, _}, cache) when is_map_key(cache, pos),
    do: {cache[pos], cache}

  # simple move down
  defp move(manifold, {pos, "."}, cache) do
    next = manifold |> Grid.get(pos, :down)

    {count, cache} =
      manifold
      |> move(next, cache)

    {count, Map.put(cache, pos, count)}
  end

  # splitter reached 
  defp move(manifold, {pos, "^"}, cache) do
    left = manifold |> Grid.get(pos, :left)
    right = manifold |> Grid.get(pos, :right)

    {left_count, cache} = manifold |> move(left, cache)
    {right_count, cache} = manifold |> move(right, cache)

    count = left_count + right_count + 1

    {count, Map.put(cache, pos, count)}
  end
end
