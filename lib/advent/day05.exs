defmodule Vent do
  import String, only: [to_integer: 1]
  @regex ~r/^(\d+),(\d+) -> (\d+),(\d+)$/

  def parse("" <> line) do
    [_, x1, y1, x2, y2] = Regex.run(@regex, line)
    {to_integer(x1), to_integer(y1), to_integer(x2), to_integer(y2)}
  end

  def draw(%{} = map, {x1, y1, x2, y2}) do
    slope_x = slope(x2 - x1)
    slope_y = slope(y2 - y1)
    stop = max(abs(x1 - x2), abs(y1 - y2))

    Enum.reduce(0..stop, map, fn n, acc ->
      x = x1 + n * slope_x
      y = y1 + n * slope_y
      Map.update(acc, {x, y}, 1, &(&1 + 1))
    end)
  end

  # helper to draw 45 degree angles
  defp slope(n) when n > 0, do: 1
  defp slope(n) when n < 0, do: -1
  defp slope(n) when n == 0, do: 0
end

lines = for line <- Advent.stream_data!("day05"), do: Vent.parse(line)

straight_lines =
  for line = {x1, y1, x2, y2} when x1 == x2 or y1 == y2 <- lines,
      do: line

# counting only horizontal and vertical line segments,
# at how many points do at least two segments overlap?
straight_lines
|> Enum.reduce(%{}, &Vent.draw(&2, &1))
|> Enum.reject(fn {_coords, count} -> count < 2 end)
|> Enum.count()
|> IO.inspect(label: "Part 1")

# part 2: at how many points do at least two segments overlap?
lines
|> Enum.reduce(%{}, &Vent.draw(&2, &1))
|> Enum.reject(fn {_coords, count} -> count < 2 end)
|> Enum.count()
|> IO.inspect(label: "Part 2")
