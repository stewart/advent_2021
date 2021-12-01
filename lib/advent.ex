defmodule Advent do
  @moduledoc "Helpers for Advent of Code puzzles."

  ## Loading Data

  def stream_data!("" <> file), do: [data_dir(), file] |> Path.join() |> File.stream!()
  def read_data!("" <> file), do: file |> stream_data!() |> Enum.to_list()
  def data_dir, do: [priv_dir(), "data"] |> Path.join()
  def priv_dir, do: :code.priv_dir(:advent)
end
