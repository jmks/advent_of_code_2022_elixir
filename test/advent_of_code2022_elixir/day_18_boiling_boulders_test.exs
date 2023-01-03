defmodule AdventOfCode2022Elixir.Day18BoilingBouldersTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day18BoilingBoulders

  @simple """
  1,1,1
  2,1,1
  """

  @example """
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
  """

  test "parse" do
    assert parse(@simple) == [{1, 1, 1}, {2, 1, 1}]
  end

  describe "sides/1" do
    test "single connection" do
      assert sides(@simple) == 10
    end

    test "example" do
      assert sides(@example) == 64
    end

    test "part 1" do
      assert sides(Input.raw(18)) == 4628
    end
  end
end
