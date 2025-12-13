defmodule Aoc.BinSearch do
  def search(tuple, predicate) when is_tuple(tuple) do
    do_search(tuple, predicate, 0, tuple_size(tuple) - 1)
  end

  defp do_search(_, _, low, high) when low > high, do: :error

  defp do_search(tuple, predicate, low, high) do
    mid = low + div(high - low, 2)
    v = elem(tuple, mid)

    case predicate.(v) do
      :eq -> mid
      :lt -> do_search(tuple, predicate, mid + 1, high)
      :gt -> do_search(tuple, predicate, low, mid)
    end
  end
end
