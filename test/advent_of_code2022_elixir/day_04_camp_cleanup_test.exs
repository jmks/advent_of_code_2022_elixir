defmodule AdventOfCode2022Elixir.Day04CampCleanupTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day04CampCleanup

  @example """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """ |> String.split("\n", trim: true)

  test "parses pair assigments" do
    assert parse(@example) == [
      [2..4, 6..8],
      [2..3, 4..5],
      [5..7, 7..9],
      [2..8, 3..7],
      [6..6, 4..6],
      [2..6, 4..8],
    ]
  end

  test "count_entirely_already_assigned/1" do
    assert count_entirely_already_assigned(@example) == 2
    assert count_entirely_already_assigned(Input.strings(4)) == 524
  end

  test "count_overlapping/1" do
    assert count_overlapping(@example) == 4
    assert count_overlapping(Input.strings(4)) == 798
  end
end
