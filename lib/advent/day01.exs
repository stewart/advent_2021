data = Advent.stream_data!("day01")

depths =
  for line <- data,
      do: line |> String.trim() |> String.to_integer()

depths
|> Enum.chunk_every(2, 1, :discard)
|> Enum.count(fn [one, two] -> two > one end)
|> IO.inspect(label: "part 1")

depths
|> Stream.chunk_every(3, 1, :discard)
|> Stream.map(fn [one, two, three] -> one + two + three end)
|> Stream.chunk_every(2, 1, :discard)
|> Enum.count(fn [one, two] -> two > one end)
|> IO.inspect(label: "part 2")
