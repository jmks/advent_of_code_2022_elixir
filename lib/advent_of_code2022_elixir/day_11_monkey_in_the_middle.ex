defmodule AdventOfCode2022Elixir.Day11MonkeyInTheMiddle do
  @moduledoc """
  --- Day 11: Monkey in the Middle ---

  As you finally start making your way upriver, you realize your pack is much lighter than you remember. Just then, one of the items from your pack goes flying overhead. Monkeys are playing Keep Away with your missing things!

  To get your stuff back, you need to be able to predict where the monkeys will throw your items. After some careful observation, you realize the monkeys operate based on how worried you are about each item.

  You take some notes (your puzzle input) on the items each monkey currently has, how worried you are about those items, and how the monkey makes decisions based on your worry level. For example:

  Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

  Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

  Monkey 2:
  Starting items: 79, 60, 97
  Operatio: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

  Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1

  Each monkey has several attributes:

    Starting items lists your worry level for each item the monkey is currently holding in the order they will be inspected.
    Operation shows how your worry level changes as that monkey inspects an item. (An operation like new = old * 5 means that your worry level after the monkey inspected the item is five times whatever your worry level was before inspection.)
    Test shows how the monkey uses your worry level to decide where to throw an item next.
        If true shows what happens with an item if the Test was true.
        If false shows what happens with an item if the Test was false.

  After each monkey inspects an item but before it tests your worry level, your relief that the monkey's inspection didn't damage the item causes your worry level to be divided by three and rounded down to the nearest integer.

  The monkeys take turns inspecting and throwing items. On a single monkey's turn, it inspects and throws all of the items it is holding one at a time and in the order listed. Monkey 0 goes first, then monkey 1, and so on until each monkey has had one turn. The process of each monkey taking a single turn is called a round.

  When a monkey throws an item to another monkey, the item goes on the end of the recipient monkey's list. A monkey that starts a round with no items could end up inspecting and throwing many items by the time its turn comes around. If a monkey is holding no items at the start of its turn, its turn ends.

  In the above example, the first round proceeds as follows:

  Monkey 0:
  Monkey inspects an item with a worry level of 79.
    Worry level is multiplied by 19 to 1501.
    Monkey gets bored with item. Worry level is divided by 3 to 500.
    Current worry level is not divisible by 23.
    Item with worry level 500 is thrown to monkey 3.
  Monkey inspects an item with a worry level of 98.
    Worry level is multiplied by 19 to 1862.
    Monkey gets bored with item. Worry level is divided by 3 to 620.
    Current worry level is not divisible by 23.
    Item with worry level 620 is thrown to monkey 3.
  Monkey 1:
  Monkey inspects an item with a worry level of 54.
    Worry level increases by 6 to 60.
    Monkey gets bored with item. Worry level is divided by 3 to 20.
    Current worry level is not divisible by 19.
    Item with worry level 20 is thrown to monkey 0.
  Monkey inspects an item with a worry level of 65.
    Worry level increases by 6 to 71.
    Monkey gets bored with item. Worry level is divided by 3 to 23.
    Current worry level is not divisible by 19.
    Item with worry level 23 is thrown to monkey 0.
  Monkey inspects an item with a worry level of 75.
    Worry level increases by 6 to 81.
    Monkey gets bored with item. Worry level is divided by 3 to 27.
    Current worry level is not divisible by 19.
    Item with worry level 27 is thrown to monkey 0.
  Monkey inspects an item with a worry level of 74.
    Worry level increases by 6 to 80.
    Monkey gets bored with item. Worry level is divided by 3 to 26.
    Current worry level is not divisible by 19.
    Item with worry level 26 is thrown to monkey 0.
  Monkey 2:
  Monkey inspects an item with a worry level of 79.
    Worry level is multiplied by itself to 6241.
    Monkey gets bored with item. Worry level is divided by 3 to 2080.
    Current worry level is divisible by 13.
    Item with worry level 2080 is thrown to monkey 1.
  Monkey inspects an item with a worry level of 60.
    Worry level is multiplied by itself to 3600.
    Monkey gets bored with item. Worry level is divided by 3 to 1200.
    Current worry level is not divisible by 13.
    Item with worry level 1200 is thrown to monkey 3.
  Monkey inspects an item with a worry level of 97.
    Worry level is multiplied by itself to 9409.
    Monkey gets bored with item. Worry level is divided by 3 to 3136.
    Current worry level is not divisible by 13.
    Item with worry level 3136 is thrown to monkey 3.
  Monkey 3:
  Monkey inspects an item with a worry level of 74.
    Worry level increases by 3 to 77.
    Monkey gets bored with item. Worry level is divided by 3 to 25.
    Current worry level is not divisible by 17.
    Item with worry level 25 is thrown to monkey 1.
  Monkey inspects an item with a worry level of 500.
    Worry level increases by 3 to 503.
    Monkey gets bored with item. Worry level is divided by 3 to 167.
    Current worry level is not divisible by 17.
    Item with worry level 167 is thrown to monkey 1.
  Monkey inspects an item with a worry level of 620.
    Worry level increases by 3 to 623.
    Monkey gets bored with item. Worry level is divided by 3 to 207.
    Current worry level is not divisible by 17.
    Item with worry level 207 is thrown to monkey 1.
  Monkey inspects an item with a worry level of 1200.
    Worry level increases by 3 to 1203.
    Monkey gets bored with item. Worry level is divided by 3 to 401.
    Current worry level is not divisible by 17.
    Item with worry level 401 is thrown to monkey 1.
  Monkey inspects an item with a worry level of 3136.
    Worry level increases by 3 to 3139.
    Monkey gets bored with item. Worry level is divided by 3 to 1046.
    Current worry level is not divisible by 17.
    Item with worry level 1046 is thrown to monkey 1.

  After round 1, the monkeys are holding items with these worry levels:

  Monkey 0: 20, 23, 27, 26
  Monkey 1: 2080, 25, 167, 207, 401, 1046
  Monkey 2:
  Monkey 3:

  Monkeys 2 and 3 aren't holding any items at the end of the round; they both inspected items during the round and threw them all before the round ended.

  This process continues for a few more round:

  After round 2, the monkeys are holding items with these worry levels:
  Monkey 0: 695, 10, 71, 135, 350
  Monkey 1: 43, 49, 58, 55, 362
  Monkey 2:
  Monkey 3:

  After round 3, the monkeys are holding items with these worry levels:
  Monkey 0: 16, 18, 21, 20, 122
  Monkey 1: 1468, 22, 150, 286, 739
  Monkey 2:
  Monkey 3:

  After round 4, the monkeys are holding items with these worry levels:
  Monkey 0: 491, 9, 52, 97, 248, 34
  Monkey 1: 39, 45, 43, 258
  Monkey 2:
  Monkey 3:

  After round 5, the monkeys are holding items with these worry levels:
  Monkey 0: 15, 17, 16, 88, 1037
  Monkey 1: 20, 110, 205, 524, 72
  Monkey 2:
  Monkey 3:

  After round 6, the monkeys are holding items with these worry levels:
  Monkey 0: 8, 70, 176, 26, 34
  Monkey 1: 481, 32, 36, 186, 2190
  Monkey 2:
  Monkey 3:

  After round 7, the monkeys are holding items with these worry levels:
  Monkey 0: 162, 12, 14, 64, 732, 17
  Monkey 1: 148, 372, 55, 72
  Monkey 2:
  Monkey 3:

  After round 8, the monkeys are holding items with these worry levels:
  Monkey 0: 51, 126, 20, 26, 136
  Monkey 1: 343, 26, 30, 1546, 36
  Monkey 2:
  Monkey 3:

  After round 9, the monkeys are holding items with these worry levels:
  Monkey 0: 116, 10, 12, 517, 14
  Monkey 1: 108, 267, 43, 55, 288
  Monkey 2:
  Monkey 3:

  After round 10, the monkeys are holding items with these worry levels:
  Monkey 0: 91, 16, 20, 98
  Monkey 1: 481, 245, 22, 26, 1092, 30
  Monkey 2:
  Monkey 3:

  ...

  After round 15, the monkeys are holding items with these worry levels:
  Monkey 0: 83, 44, 8, 184, 9, 20, 26, 102
  Monkey 1: 110, 36
  Monkey 2:
  Monkey 3:

  ...

  After round 20, the monkeys are holding items with these worry levels:
  Monkey 0: 10, 12, 14, 26, 34
  Monkey 1: 245, 93, 53, 199, 115
  Monkey 2:
  Monkey 3:

  Chasing all of the monkeys at once is impossible; you're going to have to focus on the two most active monkeys if you want any hope of getting your stuff back. Count the total number of times each monkey inspects items over 20 round:

  Monkey 0 inspected items 101 times.
  Monkey 1 inspected items 95 times.
  Monkey 2 inspected items 7 times.
  Monkey 3 inspected items 105 times.

  In this example, the two most active monkeys inspected items 101 and 105 times. The level of monkey business in this situation can be found by multiplying these together: 10605.

  Figure out which monkeys to chase by counting how many items they inspect over 20 round. What is the level of monkey business after 20 round of stuff-slinging simian shenanigans?
  n
  """
  defmodule Monkey do
    defstruct [:number, :items, :operation, :test, true, false, :total_inspections, :worry_fun]

    def new(
          number,
          operation,
          test,
          if_true,
          if_false,
          worry_fun \\ fn worry -> div(worry, 3) end
        ) do
      %__MODULE__{
        number: number,
        items: [],
        operation: operation,
        test: test,
        true: if_true,
        false: if_false,
        total_inspections: 0,
        worry_fun: worry_fun
      }
    end

    def parse(
          [title, items, operation, test, if_true, if_false],
          worry_fun \\ fn worry -> div(worry, 3) end
        ) do
      %__MODULE__{
        number:
          String.trim(title, ":") |> String.split(" ") |> List.last() |> String.to_integer(),
        items:
          String.split(items, ": ")
          |> List.last()
          |> String.split(", ", trim: true)
          |> Enum.map(&String.to_integer/1),
        operation: String.split(operation, "= ", trim: true) |> List.last() |> parse_op(),
        test: {:div, String.split(test, "divisible by ") |> List.last() |> String.to_integer()},
        true: parse_throw_to_monkey(if_true),
        false: parse_throw_to_monkey(if_false),
        total_inspections: 0,
        worry_fun: worry_fun
      }
    end

    def process(monkey, original_worry_level) do
      worry_level = operate(monkey.operation, original_worry_level)
      worry_level = monkey.worry_fun.(worry_level)

      receiver = if test(monkey.test, worry_level), do: monkey.true, else: monkey.false

      {:toss, receiver, worry_level}
    end

    def received(monkey, item) do
      %{monkey | items: monkey.items ++ [item]}
    end

    defp parse_op("old * old"), do: {:mul, :old, :old}
    defp parse_op("old * " <> num), do: {:mul, :old, String.to_integer(num)}
    defp parse_op("old + " <> num), do: {:add, :old, String.to_integer(num)}

    defp parse_throw_to_monkey(value) do
      ~r/\d+/
      |> Regex.scan(value)
      |> List.flatten()
      |> hd()
      |> String.to_integer()
    end

    defp test({:div, divisor}, value), do: rem(value, divisor) == 0

    defp operate({:mul, :old, :old}, value), do: value * value
    defp operate({:mul, :old, multiplier}, value), do: value * multiplier
    defp operate({:add, :old, addend}, value), do: value + addend
  end

  def parse(input, worry_fun \\ fn worry -> div(worry, 3) end) do
    input
    |> String.split("\n", trim: true)
    # a Monkey has 6 attributes
    |> Enum.chunk_every(6)
    |> Enum.map(&Monkey.parse(&1, worry_fun))
    |> Enum.sort_by(fn monkey -> monkey.number end)
  end

  def monkey_business(input, worry_fun \\ fn worry -> div(worry, 3) end) do
    input
    |> parse(worry_fun)
    |> round(20)
    |> Enum.map(& &1.total_inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp round(monkeys, 0), do: monkeys

  defp round(monkeys, total) do
    new_monkeys =
      monkeys
      |> :array.from_list()
      |> do_round(length(monkeys), 0)
      |> :array.to_list()

    round(new_monkeys, total - 1)
  end

  defp do_round(monkeys, max, max) do
    # summary(monkeys)

    monkeys
  end

  defp do_round(monkeys, max, current) do
    monkey = :array.get(current, monkeys)

    new_monkeys = toss(monkey, monkeys)

    new_monkey = %{
      monkey
      | items: [],
        total_inspections: monkey.total_inspections + length(monkey.items)
    }

    new_monkeys = :array.set(current, new_monkey, new_monkeys)

    do_round(new_monkeys, max, current + 1)
  end

  defp toss(monkey, original_monkeys) do
    Enum.reduce(monkey.items, original_monkeys, fn item, monkeys ->
      {:toss, target, value} = Monkey.process(monkey, item)

      new_monkey = Monkey.received(:array.get(target, monkeys), value)

      :array.set(target, new_monkey, monkeys)
    end)
  end

  defp summary(monkeys) do
    IO.puts("After round ???, the monkeys are holding items with these worry levels:")

    Enum.each(0..(:array.size(monkeys) - 1), fn index ->
      monkey = :array.get(index, monkeys)
      IO.puts("Monkey #{monkey.number} -> #{inspect(monkey.items, charlists: :as_lists)}")
    end)

    IO.puts("")
  end
end
