defmodule AdventOfCode2022Elixir.Day17PyroclasticFlowTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day17PyroclasticFlow

  alias AdventOfCode2022Elixir.Day17PyroclasticFlow.{Chamber, Rock}

  describe "Chamber" do
    test "new_starting_coordinate/1" do
      assert Chamber.new_starting_coordinate(Chamber.new()) == {2, 3}

      chamber = Chamber.new() |> Chamber.place({:whatever, [{6, 1}]})

      assert Chamber.new_starting_coordinate(chamber) == {2, 5}
    end

    test "place/2" do
      chamber = Chamber.new()

      piece =
        Rock.new(:hbar, Chamber.new_starting_coordinate(chamber))
        |> Rock.move(:down)
        |> Rock.move(:down)

      new_chamber = Chamber.place(chamber, piece)

      assert new_chamber.coordinates == MapSet.new([{2, 1}, {3, 1}, {4, 1}, {5, 1}])
    end

    test "next_rock/1" do
      chamber = Chamber.new()
      {chamber, first_rock} = Chamber.next_rock(chamber)
      {chamber, second_rock} = Chamber.next_rock(chamber)
      {chamber, third_rock} = Chamber.next_rock(chamber)
      {chamber, fourth_rock} = Chamber.next_rock(chamber)
      {chamber, fifth_rock} = Chamber.next_rock(chamber)
      {_chamber, sixth_rock} = Chamber.next_rock(chamber)

      assert first_rock == {:hbar, [{2, 3}, {3, 3}, {4, 3}, {5, 3}]}
      assert second_rock == {:plus, [{2, 4}, {3, 3}, {3, 4}, {3, 5}, {4, 4}]}
      assert third_rock == {:rev_L, [{2, 3}, {3, 3}, {4, 3}, {4, 4}, {4, 5}]}
      assert fourth_rock == {:vbar, [{2, 3}, {2, 4}, {2, 5}, {2, 6}]}
      assert fifth_rock == {:square, [{2, 3}, {2, 4}, {3, 3}, {3, 4}]}
      assert match?({:hbar, _}, sixth_rock)
    end
  end

  test "parse_jet_patterns/1" do
    assert parse_jet_patterns(">>><<><") == [
             :right,
             :right,
             :right,
             :left,
             :left,
             :right,
             :left
           ]
  end

  describe "place_rocks/2" do
    @example ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
    @jets parse_jet_patterns(@example)

    test "single piece falls to cave floor" do
      chamber = place_rocks(@jets, 1)

      assert chamber.max_h == 0
      assert chamber.coordinates ==
               MapSet.new([
                 {2, 0},
                 {3, 0},
                 {4, 0},
                 {5, 0}
               ])
    end


    test "a few fallen pieces" do
      two = place_rocks(@jets, 2)
      assert Chamber.rock_tower_height(two) == 4

      three = place_rocks(@jets, 3)
      assert Chamber.rock_tower_height(three) == 6
    end

    test "example" do
      chamber = place_rocks(@jets, 2022)

      assert Chamber.rock_tower_height(chamber) == 3068
    end

    test "part 1" do
      chamber = place_rocks(parse_jet_patterns(Input.raw(17)), 2022)

      assert Chamber.rock_tower_height(chamber) == 3209
    end
  end
end
