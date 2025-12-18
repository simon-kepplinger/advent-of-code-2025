defmodule Aoc.Day10.Part1 do
  alias Aoc.Day10.Machine
  alias Aoc.Day10.XorTree

  def run(stream) do
    stream
    |> Stream.map(&Machine.new/1)
    |> Stream.map(&XorTree.walk_machine/1)
    |> Enum.sum()
  end
end

defmodule Aoc.Day10.XorTree do
  alias Aoc.Day10.Machine

  def walk_machine(%Machine{lights: lights, buttons_bin: buttons}) do
    queue = :queue.new()
    queue = :queue.in(0, queue)

    walk(
      {lights, buttons},
      queue,
      %{}
    )
  end

  def walk({target, buttons}, queue, visited) do
    {{_, state}, queue} = :queue.out(queue)

    unless state == target do
      new_states =
        buttons
        |> Enum.map(fn {i, s} -> {i, state |> Bitwise.bxor(s)} end)
        |> Enum.filter(fn {_, s} -> not Map.has_key?(visited, s) end)

      visited =
        new_states
        |> Enum.reduce(
          visited,
          fn {_, s}, map -> Map.put(map, s, state) end
        )

      queue =
        new_states
        |> Enum.reduce(
          queue,
          fn {_, s}, queue -> :queue.in(s, queue) end
        )

      walk({target, buttons}, queue, visited)
    else
      visited |> collect(target)
    end
  end

  def collect(_, 0), do: 0

  def collect(visited, state) do
    collect(visited, visited[state]) + 1
  end
end
