defmodule Aoc.Day10.Machine do
  alias Aoc.Rational
  import Bitwise

  defstruct n: 0,
            m: 0,
            lights: 0,
            joltage: [],
            buttons_bin: [],
            buttons: [],
            matrix: %{}

  def new(line) do
    {[l], b, [j]} =
      line
      |> String.split(" ")
      |> Enum.split(1)
      |> then(fn {l, rest} ->
        Enum.split(rest, -1)
        |> Tuple.insert_at(0, l)
      end)

    {lights, n} = parse_lights(l)
    {buttons, buttons_bin} = parse_buttons(b)
    joltage = parse_joltage(j)

    m = length(buttons)

    %__MODULE__{
      n: n,
      m: m,
      lights: lights,
      buttons: buttons,
      buttons_bin: buttons_bin,
      matrix: build_matrix(n, m, buttons, joltage),
      joltage: joltage
    }
  end

  defp build_matrix(n, m, buttons, targets) do
    buttons
    |> Enum.map(fn b ->
      b
      |> Enum.reduce(
        List.duplicate(Rational.zero(), n),
        &List.replace_at(&2, &1, Rational.new(1, 1))
      )
    end)
    |> Enum.zip()
    |> Enum.map(fn t ->
      Tuple.to_list(t) |> Enum.with_index() |> Map.new(fn {v, i} -> {i, v} end)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      Enum.at(targets, i)
      |> Rational.from_int()
      |> then(&Map.put(row, m, &1))
    end)
    |> Enum.with_index()
    |> Map.new(fn {v, i} -> {i, v} end)
  end

  defp parse_lights(string) do
    ligths =
      string
      |> String.trim_leading("[")
      |> String.trim_trailing("]")
      |> String.graphemes()

    bitmap =
      ligths
      |> Enum.with_index()
      |> Enum.reduce(0, fn
        {"#", i}, acc -> acc ||| 1 <<< i
        {".", _}, acc -> acc
      end)

    {bitmap, length(ligths)}
  end

  defp parse_buttons(string) do
    buttons =
      string
      |> Enum.map(fn b ->
        b
        |> String.trim_leading("(")
        |> String.trim_trailing(")")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    buttons_bin =
      buttons
      |> Enum.map(fn b ->
        Enum.reduce(b, 0, fn i, acc -> acc ||| 1 <<< i end)
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {v, i}, map -> Map.put(map, i, v) end)

    {buttons, buttons_bin}
  end

  defp parse_joltage(string) do
    string
    |> String.slice(1, String.length(string) - 2)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defimpl String.Chars, for: Aoc.Day10.Machine do
  alias Aoc.Day10.Machine

  def to_string(%Machine{n: n, lights: lights, buttons_bin: buttons}) do
    lights =
      Integer.to_string(lights, 2)
      |> String.pad_leading(n, "0")

    buttons =
      buttons
      |> Enum.map(fn {i, b} ->
        b =
          b
          |> Integer.to_string(2)
          |> String.pad_leading(n, "0")

        "#{i}: #{b}"
      end)
      |> Enum.join("\n")

    "   #{lights}\n" <>
      "---#{String.duplicate("-", n)}\n" <>
      "#{buttons}\n"
  end
end
