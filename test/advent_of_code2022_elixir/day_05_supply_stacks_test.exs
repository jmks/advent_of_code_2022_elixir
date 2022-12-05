defmodule AdventOfCode2022Elixir.Day05SupplyStacksTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day05SupplyStacks

  alias AdventOfCode2022Elixir.Stack

  @example """
      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  describe "parse/1" do
    test "example" do
      {stacks, moves} = parse(@example)

      assert length(stacks) == 3
      starting = Enum.map(stacks, &Stack.contents/1)
      assert starting == ["NZ", "DCM", "P"]

      assert moves == [
               [1, 2, 1],
               [3, 1, 3],
               [2, 2, 1],
               [1, 1, 2]
             ]
    end

    test "gaps in assignment" do
      {stacks, _} =
        parse("""
        [D]     [Q]
            [C]
        [Z]     [P]
         1   2   3

        move 1 from 2 to 1
        """)

      assert Enum.map(stacks, &Stack.contents/1) == ["DZ", "C", "QP"]
    end
  end

  describe "apply_moves/1" do
    test "example" do
      applied = apply_moves(parse(@example))

      assert stacks_contents(applied) == ["C", "M", "ZNDP"]
    end
  end

  test "top_of_stacks/2" do
    assert top_of_stacks(parse(@example)) == "CMZ"
    assert top_of_stacks(parse(Input.raw(5))) == "MQTPGLLDN"
  end

  defp stacks_contents(stacks) do
    Enum.map(stacks, &Stack.contents/1)
  end
end
