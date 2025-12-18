defmodule Aoc.Rational do
  @moduledoc """
  simple rational type to avoid floating-point issues 
  """

  @enforce_keys [:num, :den]
  defstruct [:num, :den]

  @type t :: %__MODULE__{num: integer(), den: pos_integer()}

  @spec new(integer(), integer()) :: t()
  def new(_num, 0), do: raise(ArgumentError, "denominator cannot be 0")

  def new(num, den) when is_integer(num) and is_integer(den) do
    cond do
      num == 0 ->
        %__MODULE__{num: 0, den: 1}

      den < 0 ->
        new(-num, -den)

      true ->
        g = Integer.gcd(abs(num), den)
        %__MODULE__{num: div(num, g), den: div(den, g)}
    end
  end

  @spec from_int(integer()) :: t()
  def from_int(n) when is_integer(n), do: new(n, 1)

  @spec zero() :: t()
  def zero, do: %__MODULE__{num: 0, den: 1}

  @spec one() :: t()
  def one, do: %__MODULE__{num: 1, den: 1}

  @spec zero?(t()) :: boolean()
  def zero?(%__MODULE__{num: 0}), do: true
  def zero?(_), do: false

  @spec neg?(t()) :: boolean()
  def neg?(%__MODULE__{num: n}) when n < 0, do: true
  def neg?(_), do: false

  @spec integer?(t()) :: boolean()
  def integer?(%__MODULE__{num: n, den: d}), do: rem(n, d) == 0

  @spec to_int!(t()) :: integer()
  def to_int!(%__MODULE__{num: n, den: d}) do
    if rem(n, d) == 0,
      do: div(n, d),
      else: raise(ArgumentError, "not an integer: #{n}/#{d}")
  end

  @spec add(t(), t()) :: t()
  def add(a, b) do
    # a/b + c/d = (ad + cb) / bd
    new(a.num * b.den + b.num * a.den, a.den * b.den)
  end

  @spec sub(t(), t()) :: t()
  def sub(a, b) do
    new(a.num * b.den - b.num * a.den, a.den * b.den)
  end

  @spec mul(t(), t()) :: t()
  def mul(a, b) do
    new(a.num * b.num, a.den * b.den)
  end

  @spec divi(t(), t()) :: t()
  def divi(_a, %__MODULE__{num: 0}),
    do: raise(ArgumentError, "division by zero")

  def divi(a, b) do
    # (a/b) / (c/d) = (a/b) * (d/c)
    new(a.num * b.den, a.den * b.num)
  end

  @spec neg(t()) :: t()
  def neg(%__MODULE__{} = a), do: %__MODULE__{a | num: -a.num}

  @spec mul_int(t(), integer()) :: t()
  def mul_int(a, k) when is_integer(k), do: new(a.num * k, a.den)

  @spec eq?(t(), t()) :: boolean()
  def eq?(a, b), do: a.num == b.num and a.den == b.den

  @spec cmp(t(), t()) :: -1 | 0 | 1
  def cmp(a, b) do
    left = a.num * b.den
    right = b.num * a.den

    cond do
      left < right -> -1
      left > right -> 1
      true -> 0
    end
  end

  @spec lt?(t(), t()) :: boolean()
  def lt?(a, b), do: cmp(a, b) == -1

  @spec le?(t(), t()) :: boolean()
  def le?(a, b), do: (c = cmp(a, b)) == -1 or c == 0

  @spec to_string(t()) :: String.t()
  def to_string(%__MODULE__{num: n, den: 1}), do: Integer.to_string(n)
  def to_string(%__MODULE__{num: n, den: d}), do: "#{n}/#{d}"
end
