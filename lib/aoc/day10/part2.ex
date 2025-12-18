defmodule Aoc.Day10.Part2 do
  alias Aoc.Day10.GaussianElimination
  alias Aoc.Day10.Machine

  def run(stream) do
    stream
    |> Stream.map(&Machine.new/1)
    |> Task.async_stream(
      fn machine ->
        machine
        |> then(&GaussianElimination.new(&1.n, &1.m, &1.matrix))
        |> GaussianElimination.ref()
        |> GaussianElimination.solve()
      end,
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Stream.map(fn {:ok, v} -> v end)
    |> Enum.sum()
  end
end

defmodule Aoc.Day10.GaussianElimination do
  alias String.Chars.Aoc.Rational
  alias Aoc.Rational

  defstruct n: 0,
            m: 0,
            matrix: %{},
            pivots: %{},
            free: %{},
            u_bounds: %{}

  def new(n, m, matrix) do
    u_bounds = u_bounds(n, m, matrix)

    %__MODULE__{
      matrix: matrix,
      u_bounds: u_bounds,
      n: n,
      m: m
    }
  end

  def solve(%__MODULE__{free: free} = g) do
    case map_size(free) == 0 do
      true -> substitute_solve(g, %{})
      false -> solve(g, 0, %{}, :infinity, 0)
    end
  end

  # pruning, if sum of all current frees is larger then best, no point in going further
  def solve(_, _, _, best, curr_sum) when curr_sum >= best,
    do: best

  # all x filled -> caluclate result result and return potential new best
  def solve(%__MODULE__{free: free} = g, free_i, x, best, _)
      when map_size(free) == free_i do
    case substitute_solve(g, x) do
      :invalid -> best
      clicks -> if clicks < best, do: clicks, else: best
    end
  end

  def solve(
        %__MODULE__{
          u_bounds: u_bounds,
          free: free
        } = g,
        free_i,
        x,
        best,
        curr_sum
      ) do
    col = free[free_i]
    ub = u_bounds[col]

    0..ub
    |> Stream.map(&Map.put(x, col, Rational.from_int(&1)))
    |> Stream.map(&solve(g, free_i + 1, &1, best, curr_sum))
    |> Enum.min()
  end

  # solve all x for current free picks
  def substitute_solve(%__MODULE__{n: n, m: m, matrix: matrix} = g, x) do
    x =
      n..0//-1
      |> Stream.filter(fn row -> Map.has_key?(g.pivots, row) end)
      |> Enum.reduce(x, fn row, x ->
        res = matrix[row][m]
        start_col = g.pivots[row]
        last_col = m - 1

        val =
          case start_col < last_col do
            false ->
              Rational.divi(res, matrix[row][start_col])

            true ->
              (start_col + 1)..last_col
              |> Enum.reject(fn col -> matrix[row][col] |> Rational.zero?() end)
              |> Enum.reduce(res, fn col, res ->
                Rational.sub(
                  res,
                  Rational.mul(matrix[row][col], x[col])
                )
              end)
              |> Rational.divi(matrix[row][start_col])
          end

        Map.put(x, start_col, val)
      end)

    is_valid =
      x
      |> Enum.all?(fn {_, val} ->
        Rational.integer?(val) and
          not Rational.neg?(val)
      end)

    case is_valid do
      true ->
        x
        |> Enum.reduce(0, fn {_, rat}, sum -> Rational.to_int!(rat) + sum end)

      false ->
        :invalid
    end
  end

  def ref(%__MODULE__{} = g),
    do: ref(g, 0, 0)

  # end of ref -> fill free and return & clean "empty" rows
  defp ref(
         %__MODULE__{n: n, m: m, matrix: matrix, pivots: pivots} = g,
         row,
         col
       )
       when row >= n or col >= m do
    pivot_lookup =
      pivots
      |> Map.values()
      |> MapSet.new()

    free =
      0..(m - 1)
      |> Enum.filter(fn i -> not MapSet.member?(pivot_lookup, i) end)
      |> Enum.reduce(%{}, fn i, map -> Map.put(map, map_size(map), i) end)

    matrix =
      matrix
      |> Map.reject(fn {_, row} ->
        row |> Enum.all?(fn {_, rat} -> Rational.zero?(rat) end)
      end)

    %__MODULE__{g | matrix: matrix, free: free}
  end

  # find pivots
  defp ref(%__MODULE__{} = g, row, col) do
    case find_pivot_row(g, row, col) do
      :not_found ->
        ref(g, row, col + 1)

      pivot_row ->
        g = swap(g, pivot_row, row)

        pivot_val = g.matrix[row][col]

        g =
          g
          |> foward_elimination(col, row, pivot_val)
          |> then(fn %__MODULE__{} = g ->
            i = map_size(g.pivots)
            %__MODULE__{g | pivots: Map.put(g.pivots, i, col)}
          end)

        ref(g, row + 1, col + 1)
    end
  end

  defp find_pivot_row(%__MODULE__{n: n}, row, _) when n == row,
    do: :not_found

  defp find_pivot_row(%__MODULE__{matrix: matrix} = g, row, col) do
    if not Rational.zero?(matrix[row][col]) do
      row
    else
      find_pivot_row(g, row + 1, col)
    end
  end

  # swap two rows
  defp swap(%__MODULE__{matrix: matrix} = g, from, to) do
    from_v = Map.fetch!(matrix, from)
    to_v = Map.fetch!(matrix, to)

    %__MODULE__{g | matrix: %{matrix | to => from_v, from => to_v}}
  end

  defp foward_elimination(%__MODULE__{n: n} = g, _, row, _) when row + 1 >= n,
    do: g

  # in this column, bring every element after the pivot row to 0
  defp foward_elimination(
         %__MODULE__{n: n, matrix: matrix} = g,
         col,
         pivot_row,
         pivot_val
       ) do
    (pivot_row + 1)..(n - 1)
    |> Stream.filter(&(not Rational.zero?(matrix[&1][col])))
    |> Stream.map(fn row ->
      Rational.zero()
      |> Rational.sub(matrix[row][col])
      |> Rational.divi(pivot_val)
      |> then(&{row, &1})
    end)
    |> Enum.reduce(g, fn {row, fac}, g -> add_scaled(g, pivot_row, row, fac) end)
  end

  # add row 'from' to row 'to' factorized by 'factor'
  defp add_scaled(%__MODULE__{m: m, matrix: matrix} = g, from, to, factor) do
    pivot = matrix[from]

    target =
      0..m
      |> Enum.reduce(matrix[to], fn i, target ->
        Rational.mul(pivot[i], factor)
        |> Rational.add(target[i])
        |> then(&Map.put(target, i, &1))
      end)

    %__MODULE__{g | matrix: Map.put(matrix, to, target)}
  end

  defp u_bounds(n, m, matrix) do
    0..(m - 1)
    |> Stream.map(fn col ->
      bound =
        0..n
        |> Stream.filter(fn row -> matrix[row][col] === Rational.one() end)
        |> Stream.map(fn row -> matrix[row][m] end)
        |> Stream.map(fn rat -> Rational.to_int!(rat) end)
        |> Enum.to_list()
        |> Enum.min()

      {col, bound}
    end)
    |> Enum.reduce(%{}, fn {col, bound}, map -> Map.put(map, col, bound) end)
  end
end

defimpl String.Chars, for: Aoc.Day10.GaussianElimination do
  alias Aoc.Day10.GaussianElimination

  def to_string(%GaussianElimination{
        matrix: matrix,
        pivots: pivots,
        free: free,
        u_bounds: u_bounds
      }) do
    piv_string =
      pivots
      |> Map.values()
      |> Enum.join(", ")
      |> then(&"Pivots: [#{&1}]")

    free_string =
      free
      |> Map.values()
      |> Enum.join(", ")
      |> then(&"Free: [#{&1}]")

    bound_string =
      u_bounds
      |> Enum.map(fn {col, bound} -> "{ #{col} -> #{bound} }" end)
      |> Enum.join(", ")
      |> then(&"Bounds: [#{&1}]")

    matrix_string =
      matrix
      |> Enum.map(fn {i, row} ->
        row
        |> Enum.map(fn {_, v} -> v end)
        |> Enum.join("  ")
        |> replace_last("\s\s", " | ")
        |> then(&"R#{i}: [#{&1}]")
      end)
      |> Enum.join("\n")

    "#{piv_string}\n#{free_string}\n#{bound_string}\n#{matrix_string}\n"
  end

  def replace_last(str, match, replacement) do
    esc = Regex.escape(match)
    re = Regex.compile!(esc <> "(?!.*" <> esc <> ")")
    Regex.replace(re, str, replacement)
  end
end

defimpl String.Chars, for: Aoc.Rational do
  def to_string(%Aoc.Rational{} = r),
    do: Aoc.Rational.to_string(r)
end
