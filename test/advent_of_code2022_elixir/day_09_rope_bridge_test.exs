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

  @longer_example """
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
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
      assert rope.segments == [{-2, -1}, {-1, -1}]
    end
  end

  test "unique_tail_positions/1" do
    assert unique_tail_positions(@example, 2) == 13
    assert unique_tail_positions(Input.raw(9), 2) == 6209
  end

  test "unique_tail_positions/2" do
    assert unique_tail_positions(@example, 10) == 1
    assert unique_tail_positions(@longer_example, 10) == 36
    assert unique_tail_positions(Input.raw(9), 10) == 2460
  end
end
