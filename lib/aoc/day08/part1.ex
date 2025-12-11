defmodule Aoc.Day08.Part1 do
  alias Aoc.Day08.BoxConnector

  @n if Mix.env() == :test, do: 10, else: 1000

  def run(stream) do
    connect_boxes(stream, @n)
    |> BoxConnector.result()
  end

  def connect_boxes(stream, n) do
    boxes =
      stream
      |> Stream.map(&String.split(&1, ","))
      |> Stream.map(fn l -> Enum.map(l, &String.to_integer/1) end)
      |> Stream.map(&List.to_tuple/1)
      |> Enum.to_list()

    box_map =
      boxes
      |> Enum.chunk_every(50)
      |> Task.async_stream(
        fn chunk -> Enum.flat_map(chunk, &get_closest(&1, boxes)) end,
        max_concurrency: System.schedulers_online(),
        ordered: false
      )
      |> Stream.flat_map(fn {:ok, result} -> result end)
      |> Enum.sort_by(fn {_, d} -> d end)
      |> take(n, 2)
      |> Enum.map(fn {{a, b}, _} -> {a, b} end)
      |> Enum.map(&sort_pair/1)
      |> Enum.dedup()
      |> take(n)

    box_map
    |> Enum.reduce(
      BoxConnector.new(),
      &BoxConnector.connect_pair(&2, &1)
    )
  end

  defp sort_pair({a, b}) when a <= b, do: {a, b}
  defp sort_pair({a, b}), do: {b, a}

  defp get_closest(box, boxes) do
    boxes
    |> Enum.reject(&(&1 == box))
    |> Enum.map(&{&1, distance(box, &1)})
    |> Enum.sort_by(fn {_, d} -> d end)
    # using a fixed value of 100 still works and greatly improves runtime.
    |> take(100)
    |> Enum.map(fn {other, d} -> {{box, other}, d} end)
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt(
      :math.pow(x1 - x2, 2) +
        :math.pow(y1 - y2, 2) +
        :math.pow(z1 - z2, 2)
    )
  end

  defp take(_, _, _ \\ 1)
  defp take(enum, :all, _), do: enum
  defp take(enum, n, fac), do: Enum.take(enum, n * fac)
end

defmodule Aoc.Day08.BoxConnector do
  defstruct reverse_lookup: %{},
            lookup: %{},
            next_id: 0,
            last_connection: 0

  def new, do: %__MODULE__{}

  def result(%__MODULE__{lookup: lookup}) do
    lookup
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.frequencies()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, &*/2)
  end

  def update_last_connection(
        %__MODULE__{} = connector,
        a_id,
        b_id,
        {{x1, _, _}, {x2, _, _}}
      )
      when a_id == nil or b_id == nil do
    %__MODULE__{
      connector
      | last_connection: x1 * x2
    }
  end

  def update_last_connection(connector, _, _, _), do: connector

  def(connect_pair(connector, {a, b})) do
    a_id = get_pool_id(connector, a)
    b_id = get_pool_id(connector, b)

    connector
    |> update_last_connection(a_id, b_id, {a, b})
    |> connect_with_ids({{a_id, a}, {b_id, b}})
  end

  # create new pool with both
  defp connect_with_ids(connector, {{nil, a}, {nil, b}}) do
    id = connector.next_id

    connector
    |> connect(a, nil)
    |> connect(b, id)
  end

  # connect a to pool from b
  defp connect_with_ids(connector, {{nil, a}, {id, _}}),
    do: connect(connector, a, id)

  # connect b to pool from a
  defp connect_with_ids(connector, {{id, _}, {nil, b}}),
    do: connect(connector, b, id)

  # connect two boxes in the same
  defp connect_with_ids(connector, {{a_id, _}, {b_id, _}}) when a_id == b_id,
    do: connector

  # merge pool from b into pool from a
  defp connect_with_ids(
         %__MODULE__{
           reverse_lookup: reverse_lookup,
           lookup: lookup,
           next_id: next_id,
           last_connection: last_connection
         },
         {{a_id, _}, {b_id, _}}
       ) do
    a_pool = reverse_lookup[a_id]
    b_pool = reverse_lookup[b_id]
    pool = MapSet.union(a_pool, b_pool)

    # set the merged pool to a and remove pool from b 
    reverse_lookup =
      reverse_lookup
      |> Map.put(a_id, pool)
      |> Map.delete(b_id)

    # rewrite lookups for all in b to be a_id now
    lookup =
      b_pool
      |> Enum.reduce(lookup, &Map.put(&2, &1, a_id))

    %__MODULE__{
      reverse_lookup: reverse_lookup,
      lookup: lookup,
      next_id: next_id,
      last_connection: last_connection
    }
  end

  defp connect(
         %__MODULE__{
           reverse_lookup: reverse_lookup,
           lookup: lookup,
           next_id: next_id,
           last_connection: last_connection
         },
         box,
         nil
       ) do
    pool = MapSet.new([box])

    %__MODULE__{
      reverse_lookup: Map.put(reverse_lookup, next_id, pool),
      lookup: Map.put(lookup, box, next_id),
      next_id: next_id + 1,
      last_connection: last_connection
    }
  end

  defp connect(
         %__MODULE__{
           reverse_lookup: reverse_lookup,
           lookup: lookup,
           next_id: next_id,
           last_connection: last_connection
         },
         box,
         id
       ) do
    pool =
      reverse_lookup[id]
      |> MapSet.put(box)

    %__MODULE__{
      reverse_lookup: Map.put(reverse_lookup, id, pool),
      lookup: Map.put(lookup, box, id),
      next_id: next_id,
      last_connection: last_connection
    }
  end

  defp get_pool_id(connector, box),
    do: connector.lookup[box]
end
