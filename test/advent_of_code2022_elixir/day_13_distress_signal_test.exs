defmodule AdventOfCode2022Elixir.Day13DistressSignalTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day13DistressSignal

  @example """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  describe "parse/1" do
    assert parse("""
           [1,1,3,1,1]
           [1,1,5,1,1]
           """) == [[[1, 1, 3, 1, 1], [1, 1, 5, 1, 1]]]
  end

  test "right_packet_order?/1" do
    assert right_packet_order?([1, 1, 3, 1, 1], [1, 1, 5, 1, 1])
    refute right_packet_order?([1, 1, 5, 1, 1], [1, 1, 3, 1, 1])
    assert right_packet_order?([1, 1], [1, 1, 1])
    refute right_packet_order?([1, 1, 1], [1, 1])
    assert right_packet_order?([[1], [2, 3, 4]], [[1], 4])
    refute right_packet_order?([9], [[8, 7, 6]])
    assert right_packet_order?([[4, 4], 4, 4], [[4, 4], 4, 4, 4])
    refute right_packet_order?([[[]]], [[]])

    refute right_packet_order?([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [
             1,
             [2, [3, [4, [5, 6, 0]]]],
             8,
             9
           ])
  end

  test "index_sum_of_right_order/1" do
    assert index_sum_of_right_order(@example) == 13
    assert index_sum_of_right_order(Input.raw(13)) == 5252
  end
end
