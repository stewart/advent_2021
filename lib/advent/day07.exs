defmodule Crabs do
  def parse("" <> swarm) do
    swarm
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # find the position costing least overall fuel to align to.
  # how much fuel must all of the crabs spend to align there?
  def optimal_alignment_cost(crabs, opts \\ []) do
    align_to = optimal_alignment_position(crabs, opts)

    Enum.reduce(crabs, 0, fn current_position, overall_cost ->
      distance = abs(current_position - align_to)
      overall_cost + fuel_cost(distance, opts)
    end)
  end

  defp optimal_alignment_position(crabs, opts) do
    {min, max} = Enum.min_max(crabs)

    Enum.min_by(min..max, fn position ->
      Enum.reduce(crabs, 0, fn current_position, overall_cost ->
        distance = abs(current_position - position)
        overall_cost + fuel_cost(distance, opts)
      end)
    end)
  end

  defp fuel_cost(distance, opts) do
    if Keyword.get(opts, :advanced_crab_engineering) do
      div(distance * (distance + 1), 2)
    else
      distance
    end
  end
end

crabs =
  Advent.read_data!("day07")
  |> Crabs.parse()

crabs
|> Crabs.optimal_alignment_cost()
|> IO.inspect(label: "Part 1")

crabs
|> Crabs.optimal_alignment_cost(advanced_crab_engineering: true)
|> IO.inspect(label: "Part 2")
