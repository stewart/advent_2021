defmodule Board do
  # each space can be :marked or :unmarked
  defstruct [:spaces]

  def new([r | _] = rows) when is_list(r) do
    spaces =
      Enum.map(rows, fn row ->
        Enum.map(row, &{&1, :unmarked})
      end)

    %__MODULE__{
      spaces: spaces
    }
  end

  def mark(%__MODULE__{spaces: spaces} = board, number) do
    all_unmarked_spaces_matching_number = [
      Access.all(),
      Access.filter(fn {num, status} -> num == number && status == :unmarked end)
    ]

    mark = fn {^number, :unmarked} -> {number, :marked} end
    %__MODULE__{board | spaces: update_in(spaces, all_unmarked_spaces_matching_number, mark)}
  end

  def bingo?(%__MODULE__{} = board) do
    winning_columns?(board) || winning_rows?(board)
  end

  def winning_rows?(%__MODULE__{spaces: rows}) do
    all_marked? = &Enum.all?(&1, fn {_, status} -> status == :marked end)
    Enum.any?(rows, all_marked?)
  end

  def winning_columns?(%__MODULE__{spaces: spaces}) do
    columns = spaces |> Stream.zip() |> Stream.map(&Tuple.to_list/1)
    all_marked? = &Enum.all?(&1, fn {_, status} -> status == :marked end)
    Enum.any?(columns, all_marked?)
  end

  def score(%__MODULE__{spaces: spaces}, final_called_number) do
    sum_of_unmarked_spaces = Enum.sum(for row <- spaces, {n, :unmarked} <- row, do: n)
    sum_of_unmarked_spaces * final_called_number
  end
end

defmodule Bingo do
  def parse("" <> input) do
    import String, only: [split: 2, split: 3, to_integer: 1]

    parse_line = fn line -> line |> split(" ", trim: true) |> Enum.map(&to_integer/1) end

    [numbers_str | boards_strs] = split(input, "\n", trim: true)

    numbers = for n <- split(numbers_str, ","), do: to_integer(n)

    boards =
      boards_strs
      |> Enum.map(parse_line)
      |> Enum.chunk_every(5)
      |> Enum.map(&Board.new/1)

    {numbers, boards}
  end
end

input = Advent.read_data!("day04")
{numbers, boards} = Bingo.parse(input)

# find the first board that will win
Enum.reduce_while(numbers, {boards, _called = []}, fn
  number, {boards, called} ->
    updated_boards =
      for board <- boards,
          do: Board.mark(board, number)

    case Enum.split_with(updated_boards, &Board.bingo?/1) do
      {[winner | _], _} -> {:halt, Board.score(winner, number)}
      {_, in_play} -> {:cont, {in_play, [number | called]}}
    end
end)
|> IO.inspect(label: "Part 1")

# find the _last_ board that will win
Enum.reduce_while(numbers, {boards, _called = []}, fn
  number, {boards, called} ->
    updated_boards =
      for board <- boards,
          do: Board.mark(board, number)

    case Enum.split_with(updated_boards, &Board.bingo?/1) do
      {[winner | _], []} -> {:halt, Board.score(winner, number)}
      {_, in_play} -> {:cont, {in_play, [number | called]}}
    end
end)
|> IO.inspect(label: "Part 2")
