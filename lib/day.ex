defmodule Aoc.Day do
  @moduledoc """
  Utilities for working with day input files.
  """

  @input_dir Path.expand("../priv/in", __DIR__)

  @doc """
  Returns the absolute path to the input file for `day`.
  """
  def in_path(day) do
    File.mkdir_p!(@input_dir)
    Path.join(@input_dir, "day#{pad2(day)}")
  end

  @doc """
  Reads the raw puzzle input for `day` from `priv/in/dayXX`.
  """
  def read_in(day) do
    day
    |> in_path()
    |> File.read!()
  end

  def pad2(day) when is_integer(day),
    do:
      day
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

  def pad2(day) when is_binary(day),
    do:
      day
      |> String.to_integer()
      |> pad2()
end
