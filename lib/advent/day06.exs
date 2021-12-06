# exponential problem!

defmodule Fishes do
  import Map, only: [get: 3]

  def new("" <> input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  def tick(%{} = fishes) do
    %{
      0 => get(fishes, 1, 0),
      1 => get(fishes, 2, 0),
      2 => get(fishes, 3, 0),
      3 => get(fishes, 4, 0),
      4 => get(fishes, 5, 0),
      5 => get(fishes, 6, 0),
      6 => get(fishes, 7, 0) + get(fishes, 0, 0),
      7 => get(fishes, 8, 0),
      8 => get(fishes, 0, 0)
    }
  end

  def simulate(0, %{} = fishes), do: fishes
  def simulate(n, %{} = fishes) when n >= 1, do: simulate(n - 1, tick(fishes))

  def count(%{} = fishes) do
    Enum.reduce(fishes, 0, fn {_, count}, acc -> acc + count end)
  end
end

fishes =
  Advent.read_data!("day06")
  |> String.trim()
  |> Fishes.new()

# part 1: how many fish after 80 days?
80
|> Fishes.simulate(fishes)
|> Fishes.count()
|> IO.inspect(label: "Part 1")

# part 1: how many fish after 256 days?
256
|> Fishes.simulate(fishes)
|> Fishes.count()
|> IO.inspect(label: "Part 2")
