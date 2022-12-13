defmodule AdventOfCode2022Elixir.Day11MonkeyInTheMiddleTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day11MonkeyInTheMiddle

  alias AdventOfCode2022Elixir.Day11MonkeyInTheMiddle.Monkey

  @example """
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
  """

  test "parse/1" do
    [monkey] =
      parse("""
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3
      """)

    assert monkey.number == 0
    assert monkey.items == [79, 98]
    assert monkey.operation == {:mul, :old, 19}
    assert monkey.test == {:div, 23}
    assert monkey.true == 2
    assert monkey.false == 3
  end

  describe "Monkey" do
    test "process/1" do
      monkey = Monkey.new(0, {:mul, :old, 19}, {:div, 23}, 3, 5)

      assert Monkey.process(monkey, 79) == {:toss, 5, 500}
      assert Monkey.process(monkey, 19 * 3 * 23) == {:toss, 3, 8303}
    end
  end

  test "monkey_business/1" do
    assert monkey_business(@example) == 10605
    assert monkey_business(Input.raw(11)) == 118_674
  end
end
