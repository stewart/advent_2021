defmodule Diagnostic do
  def decode_row("" <> input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
  end

  def gamma(report) do
    bits =
      for bit_counts <- sample_frequencies(report),
          {bit, _} = Enum.max_by(bit_counts, &elem(&1, 1)),
          into: "",
          do: bit

    String.to_integer(bits, 2)
  end

  def epsilon(report) do
    bits =
      for bit_counts <- sample_frequencies(report),
          {bit, _} = Enum.min_by(bit_counts, &elem(&1, 1)),
          into: "",
          do: bit

    String.to_integer(bits, 2)
  end

  # part 2: sieving numbers until we have one left using differing criteria:

  # keep numbers with the most common bit in each position until you have one left
  # if 1 and 0 are equally common, prefer 1
  def oxygen_generator_rating(report) do
    loop = Stream.cycle([:ok])

    Enum.reduce_while(loop, {report, _depth = 0}, fn
      _, {[rating], _depth} ->
        {:halt, rating}

      _, {[_ | _] = options, depth} ->
        target_bit =
          case Enum.at(sample_frequencies(options), depth) do
            %{"1" => x, "0" => y} when x == y -> "1"
            %{"1" => x, "0" => y} when x > y -> "1"
            %{"1" => x, "0" => y} when x < y -> "0"
          end

        new_options = Enum.filter(options, &(Enum.at(&1, depth) == target_bit))
        {:cont, {new_options, depth + 1}}
    end)
    |> Enum.join("")
    |> String.to_integer(2)
  end

  # keep numbers with the least common bit in each position until you have one left
  # if 1 and 0 are equally common, prefer 0
  def co2_scrubber_rating(report) do
    loop = Stream.cycle([:ok])

    Enum.reduce_while(loop, {report, _depth = 0}, fn
      _, {[rating], _depth} ->
        {:halt, rating}

      _, {[_ | _] = options, depth} ->
        target_bit =
          case Enum.at(sample_frequencies(options), depth) do
            %{"1" => x, "0" => y} when x == y -> "0"
            %{"1" => x, "0" => y} when x > y -> "0"
            %{"1" => x, "0" => y} when x < y -> "1"
          end

        new_options = Enum.filter(options, &(Enum.at(&1, depth) == target_bit))
        {:cont, {new_options, depth + 1}}
    end)
    |> Enum.join("")
    |> String.to_integer(2)
  end

  defp sample_frequencies(report) do
    for slice <- Enum.zip(report),
        sample = Tuple.to_list(slice),
        do: Enum.frequencies(sample)
  end
end

report =
  for row <- Advent.stream_data!("day03"),
      do: Diagnostic.decode_row(row)

power_consumption = Diagnostic.epsilon(report) * Diagnostic.gamma(report)

IO.inspect(power_consumption, label: "Part 1")

life_support_rating =
  Diagnostic.oxygen_generator_rating(report) * Diagnostic.co2_scrubber_rating(report)

IO.inspect(life_support_rating, label: "Part 2")
