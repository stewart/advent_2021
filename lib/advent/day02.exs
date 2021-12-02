data = Advent.stream_data!("day02")

instructions =
  for line <- Stream.map(data, &String.trim/1),
  [direction, distance] = String.split(line, " ", parts: 2),
  do: {String.to_atom(direction), String.to_integer(distance)}

instructions
|> Enum.reduce({_x = 0, _y = 0}, fn
  {:forward, n}, {x, y} -> {x + n, y}
  {:down, n}, {x, y} -> {x, y + n}
  {:up, n}, {x, y} -> {x, y - n}
end)
|> Kernel.then(fn {x, y} -> x * y end)
|> IO.inspect(label: "Part 1")

instructions
|> Enum.reduce({_x = 0, _y = 0, _aim = 0}, fn
  {:forward, n}, {x, y, a} -> {x + n, y + (a * n), a}
  {:down, n}, {x, y, a} -> {x, y, a + n}
  {:up, n}, {x, y, a} -> {x, y, a - n}
end)
|> Kernel.then(fn {x, y, _a} -> x * y end)
|> IO.inspect(label: "Part 2")
