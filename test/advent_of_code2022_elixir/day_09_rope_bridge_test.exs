defmodule AdventOfCode2022Elixir.Day09RopeBridgeTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day09RopeBridge

  alias AdventOfCode2022Elixir.Day09RopeBridge.Rope

  @example """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  describe "Rope" do
    import Rope, except: [unique_tail_positions: 1]

    test "tail follows head to the right" do
      rope = new() |> move(:right, 4)

      assert Rope.unique_tail_positions(rope) == 4
    end

    test "tail follows head to the left" do
      rope = new() |> move(:left, 3)

      assert Rope.unique_tail_positions(rope) == 3
    end

    test "tail follows head at an angle" do
      rope = new() |> move(:down, 1) |> move(:left, 1) |> move(:left, 1)

      assert Rope.unique_tail_positions(rope) == 2
      assert rope.head == {-2, -1}
      assert rope.tail == {-1, -1}
    end
  end

  test "unique_tail_positions/1" do
    assert unique_tail_positions(@example) == 13
    assert unique_tail_positions(Input.raw(9)) == 6209
  end
end
