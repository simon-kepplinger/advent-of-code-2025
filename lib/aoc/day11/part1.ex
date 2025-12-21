defmodule Aoc.Day11.Part1 do
  def run(stream) do
    map =
      stream
      |> Enum.map(fn line -> String.split(line, ":") end)
      |> Enum.reduce(%{}, fn [key | [rest]], map ->
        outputs =
          rest
          |> String.trim()
          |> String.split(" ")

        Map.put(map, key, outputs)
      end)

    dfs(map, "you")
  end

  def dfs(_, "out"),
    do: 1

  def dfs(map, key) do
    map[key]
    |> Enum.map(&dfs(map, &1))
    |> Enum.sum()
  end
end
