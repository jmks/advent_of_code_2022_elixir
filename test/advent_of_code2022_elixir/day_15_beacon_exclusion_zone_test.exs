defmodule AdventOfCode2022Elixir.Day15BeaconExclusionZoneTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day15BeaconExclusionZone

  @example """
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  """

  test "parse/1" do
    assert Enum.take(parse(@example), 3) == [
             {{:sensor, {2, 18}}, {:beacon, {-2, 15}}},
             {{:sensor, {9, 16}}, {:beacon, {10, 16}}},
             {{:sensor, {13, 2}}, {:beacon, {15, 3}}}
           ]
  end

  test "manhattan_distance/2" do
    assert manhattan_distance({0, 0}, {1, 1}) == 2
    assert manhattan_distance({0, 0}, {3, 2}) == 5
  end

  test "positions_without_beacon/2" do
    assert positions_without_beacon(@example, 10) == 26
  end

  @tag :slow
  test "part 1" do
    assert positions_without_beacon(Input.raw(15), 2_000_000) == 5_125_700
  end
end
