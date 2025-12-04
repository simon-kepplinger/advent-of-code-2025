defmodule Aoc.Day03.Part2 do
  def run(stream) do
    stream
    |> Stream.map(&JoltageServer.start/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn pid -> tap(pid, &JoltageServer.calc/1) end)
    |> Enum.map(&JoltageServer.get/1)
    |> Enum.sum()
  end

  def get_hi(line, digits) do
    size = String.length(line)

    (digits - 1)..0//-1
    |> Stream.map(&(size - &1))
    |> Stream.scan(-1, &get_hi_index(line, &2 + 1, &1))
    |> Stream.map(&String.at(line, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  defp get_hi_index(line, from, to) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.slice(from, to - from)
    |> Enum.max_by(&elem(&1, 0))
    |> elem(1)
  end
end

# using GenServer here for educational purpose
defmodule JoltageServer do
  use GenServer

  alias Aoc.Day03.Part2

  def start(line) do
    GenServer.start(JoltageServer, line)
  end

  def calc(pid) do
    GenServer.cast(pid, nil)
  end

  def get(pid) do
    GenServer.call(pid, nil)
  end

  def init(line) do
    {:ok, {line, 0}}
  end

  def handle_cast(_, {line, _}) do
    num = Part2.get_hi(line, 12)

    {:noreply, {line, num}}
  end

  def handle_call(_, _, {line, num}) do
    {:reply, num, {line, num}}
  end
end
