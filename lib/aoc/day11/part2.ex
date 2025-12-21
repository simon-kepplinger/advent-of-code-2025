defmodule Aoc.Day11.Part2 do
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

    {answer, _} = dfs(map, "svr", false, false, %{})

    answer
  end

  def dfs(_, "out", true, true, cache),
    do: {1, cache}

  def dfs(_, "out", _, _, cache),
    do: {0, cache}

  def dfs(map, key, fft, dac, cache) do
    fft = fft or key === "fft"
    dac = dac or key === "dac"

    cache_key = {key, fft, dac}

    case cache do
      %{^cache_key => count} ->
        {count, cache}

      _ ->
        {sum, cache} =
          map[key]
          |> Enum.reduce({0, cache}, fn key, {count, cache} ->
            {res, cache} = dfs(map, key, fft, dac, cache)
            {count + res, cache}
          end)

        cache = Map.put(cache, cache_key, sum)
        {sum, cache}
    end
  end
end
