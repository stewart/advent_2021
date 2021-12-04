defmodule Board do
  # boards are a 5/5 grid
  @size 5

  # each space can be :marked or :unmarked
  defstruct [:spaces]

  def new([r | _] = rows) when is_list(r) do
    spaces = Enum.map(rows, fn row ->
      Enum.map(row, & {&1, :unmarked})
    end)

    %__MODULE__{
      spaces: spaces
    }
  end

  def call(%__MODULE__{spaces: spaces} = board, number) do
    all_unmarked_spaces_matching_number =
      [
        Access.all(),
        Access.filter(fn {num, status} -> num == number && status == :unmarked end)
      ]

    new_spaces =
      update_in(
        spaces,
        all_unmarked_spaces_matching_number,
        fn {^number, :unmarked} -> {number, :marked} end
      )

    %__MODULE__{board | spaces: new_spaces}
  end

  def won?(%__MODULE__{} = board) do
    winning_columns?(board) || winning_rows?(board)
  end

  def winning_rows?(%__MODULE__{spaces: spaces}) do
    Enum.any?(spaces, fn row ->
      Enum.all?(row, fn {_, status} -> status == :marked end)
    end)
  end

  def winning_columns?(%__MODULE__{spaces: spaces}) do
    columns = Enum.zip(spaces)

    Enum.any?(columns, fn col ->
      Enum.all?(row, fn {_, status} -> status == :marked end)
    end)
  end

  def score(%__MODULE__{spaces: spaces}, final_called_number) do
    sum_of_unmarked_spaces =
      spaces
      |> Enum.flat_map(fn row -> for {n, :unmarked} <- row, do: n end)
      |> Enum.sum()

    sum_of_unmarked_spaces * final_called_number
  end
end

defmodule Bingo do
  def parse("" <> input) do
    import String, only: [split: 2, split: 3, to_integer: 1]

    parse_line =
      fn line -> line |> split(" ", trim: true) |> Enum.map(&to_integer/1) end

    [numbers_str | boards_strs] = split(input, "\n", trim: true)

    numbers =
      for n <- split(numbers_str, ","), do: to_integer(n)

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

winning_board =
  Enum.reduce_while(Stream.cycle([:ok]), {boards, numbers}, fn _, {boards, [number | next]} ->
  end)
