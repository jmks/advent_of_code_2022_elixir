defmodule AdventOfCode2022Elixir.Day14RegolithReservoirTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day14RegolithReservoir

  alias AdventOfCode2022Elixir.Day14RegolithReservoir.Cave

  @example """
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  describe "Cave" do
    test "parse/1" do
      cave = Cave.parse(@example)

      assert {498, 4} in cave.rocks
      assert {498, 5} in cave.rocks
      assert {498, 6} in cave.rocks
      assert {497, 6} in cave.rocks
      assert {496, 6} in cave.rocks

      assert {503, 4} in cave.rocks
      assert {502, 4} in cave.rocks
      assert {502, 5} in cave.rocks
      assert {502, 6} in cave.rocks
      assert {502, 7} in cave.rocks
      assert {502, 8} in cave.rocks
      assert {502, 9} in cave.rocks
      assert {501, 9} in cave.rocks
      assert {500, 9} in cave.rocks
      assert {499, 9} in cave.rocks
      assert {498, 9} in cave.rocks
      assert {497, 9} in cave.rocks
      assert {496, 9} in cave.rocks
      assert {495, 9} in cave.rocks
      assert {494, 9} in cave.rocks
    end

    test "draw/1" do
      drawing = Cave.parse(@example) |> Cave.draw()

      expected =
        """
        ......+...
        ..........
        ..........
        ..........
        ....#...##
        ....#...#.
        ..###...#.
        ........#.
        ........#.
        #########.
        """
        |> String.trim()

      assert drawing == expected
    end

    test "fill_with_sand/1" do
      assert @example |> Cave.parse() |> Cave.fill_with_sand() == 24
      assert Input.raw(14) |> Cave.parse() |> Cave.fill_with_sand() == 793
    end

    test "fill_with_sand/2" do
      assert @example |> Cave.parse() |> Cave.fill_with_sand(:block_source) == 93
      assert Input.raw(14) |> Cave.parse() |> Cave.fill_with_sand(:block_source) == 24166
    end
  end
end
