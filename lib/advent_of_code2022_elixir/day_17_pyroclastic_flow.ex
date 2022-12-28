defmodule AdventOfCode2022Elixir.Day17PyroclasticFlow do
  @moduledoc """
  --- Day 17: Pyroclastic Flow ---

  Your handheld device has located an alternative exit from the cave for you and the elephants. The ground is rumbling almost continuously now, but the strange valves bought you some time. It's definitely getting warmer in here, though.

  The tunnels eventually open into a very tall, narrow chamber. Large, oddly-shaped rocks are falling into the chamber from above, presumably due to all the rumbling. If you can't work out where the rocks will fall next, you might be crushed!

  The five types of rocks have the following peculiar shapes, where # is rock and . is empty space:

  ####

  .#.
  ###
  .#.

  ..#
  ..#
  ###

  #
  #
  #
  #

  ##
  ##

  The rocks fall in the order shown above: first the - shape, then the + shape, and so on. Once the end of the list is reached, the same order repeats: the - shape falls first, sixth, 11th, 16th, etc.

  The rocks don't spin, but they do get pushed around by jets of hot gas coming out of the walls themselves. A quick scan reveals the effect the jets of hot gas will have on the rocks as they fall (your puzzle input).

  For example, suppose this was the jet pattern in your cave:

  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>

  In jet patterns, < means a push to the left, while > means a push to the right. The pattern above means that the jets will push a falling rock right, then right, then right, then left, then left, then right, and so on. If the end of the list is reached, it repeats.

  The tall, vertical chamber is exactly seven units wide. Each rock appears so that its left edge is two units away from the left wall and its bottom edge is three units above the highest rock in the room (or the floor, if there isn't one).

  After a rock appears, it alternates between being pushed by a jet of hot gas one unit (in the direction indicated by the next symbol in the jet pattern) and then falling one unit down. If any movement would cause any part of the rock to move into the walls, floor, or a stopped rock, the movement instead does not occur. If a downward movement would have caused a falling rock to move into the floor or an already-fallen rock, the falling rock stops where it is (having landed on something) and a new rock immediately begins falling.

  Drawing falling rocks with @ and stopped rocks with #, the jet pattern in the example above manifests as follows:

  The first rock begins falling:
  |..@@@@.|
  |.......|
  |.......|
  |.......|
  +-------+

  Jet of gas pushes rock right:
  |...@@@@|
  |.......|
  |.......|
  |.......|
  +-------+

  Rock falls 1 unit:
  |...@@@@|
  |.......|
  |.......|
  +-------+

  Jet of gas pushes rock right, but nothing happens:
  |...@@@@|
  |.......|
  |.......|
  +-------+

  Rock falls 1 unit:
  |...@@@@|
  |.......|
  +-------+

  Jet of gas pushes rock right, but nothing happens:
  |...@@@@|
  |.......|
  +-------+

  Rock falls 1 unit:
  |...@@@@|
  +-------+

  Jet of gas pushes rock left:
  |..@@@@.|
  +-------+

  Rock falls 1 unit, causing it to come to rest:
  |..####.|
  +-------+

  A new rock begins falling:
  |...@...|
  |..@@@..|
  |...@...|
  |.......|
  |.......|
  |.......|
  |..####.|
  +-------+

  Jet of gas pushes rock left:
  |..@....|
  |.@@@...|
  |..@....|
  |.......|
  |.......|
  |.......|
  |..####.|
  +-------+

  Rock falls 1 unit:
  |..@....|
  |.@@@...|
  |..@....|
  |.......|
  |.......|
  |..####.|
  +-------+

  Jet of gas pushes rock right:
  |...@...|
  |..@@@..|
  |...@...|
  |.......|
  |.......|
  |..####.|
  +-------+

  Rock falls 1 unit:
  |...@...|
  |..@@@..|
  |...@...|
  |.......|
  |..####.|
  +-------+

  Jet of gas pushes rock left:
  |..@....|
  |.@@@...|
  |..@....|
  |.......|
  |..####.|
  +-------+

  Rock falls 1 unit:
  |..@....|
  |.@@@...|
  |..@....|
  |..####.|
  +-------+

  Jet of gas pushes rock right:
  |...@...|
  |..@@@..|
  |...@...|
  |..####.|
  +-------+

  Rock falls 1 unit, causing it to come to rest:
  |...#...|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  A new rock begins falling:
  |....@..|
  |....@..|
  |..@@@..|
  |.......|
  |.......|
  |.......|
  |...#...|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  The moment each of the next few rocks begins falling, you would see this:

  |..@....|
  |..@....|
  |..@....|
  |..@....|
  |.......|
  |.......|
  |.......|
  |..#....|
  |..#....|
  |####...|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |..@@...|
  |..@@...|
  |.......|
  |.......|
  |.......|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |..@@@@.|
  |.......|
  |.......|
  |.......|
  |....##.|
  |....##.|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |...@...|
  |..@@@..|
  |...@...|
  |.......|
  |.......|
  |.......|
  |.####..|
  |....##.|
  |....##.|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |....@..|
  |....@..|
  |..@@@..|
  |.......|
  |.......|
  |.......|
  |..#....|
  |.###...|
  |..#....|
  |.####..|
  |....##.|
  |....##.|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |..@....|
  |..@....|
  |..@....|
  |..@....|
  |.......|
  |.......|
  |.......|
  |.....#.|
  |.....#.|
  |..####.|
  |.###...|
  |..#....|
  |.####..|
  |....##.|
  |....##.|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |..@@...|
  |..@@...|
  |.......|
  |.......|
  |.......|
  |....#..|
  |....#..|
  |....##.|
  |....##.|
  |..####.|
  |.###...|
  |..#....|
  |.####..|
  |....##.|
  |....##.|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  |..@@@@.|
  |.......|
  |.......|
  |.......|
  |....#..|
  |....#..|
  |....##.|
  |##..##.|
  |######.|
  |.###...|
  |..#....|
  |.####..|
  |....##.|
  |....##.|
  |....#..|
  |..#.#..|
  |..#.#..|
  |#####..|
  |..###..|
  |...#...|
  |..####.|
  +-------+

  To prove to the elephants your simulation is accurate, they want to know how tall the tower will get after 2022 rocks have stopped (but before the 2023rd rock begins falling). In this example, the tower of rocks will be 3068 units tall.

  How many units tall will the tower of rocks be after 2022 rocks have stopped falling?
  """
  defmodule Rock do
    def new(:hbar, {x, y}) do
      {:hbar, for(i <- 0..3, do: {x + i, y})}
    end

    def new(:plus, {x, y}) do
      coordinates = [
        {x, y + 1},
        {x + 1, y},
        {x + 1, y + 1},
        {x + 1, y + 2},
        {x + 2, y + 1}
      ]

      {:plus, coordinates}
    end

    def new(:rev_L, {x, y}) do
      coordinates = [
        {x, y},
        {x + 1, y},
        {x + 2, y},
        {x + 2, y + 1},
        {x + 2, y + 2}
      ]

      {:rev_L, coordinates}
    end

    def new(:square, {x, y}) do
      coordinates = [
        {x, y},
        {x, y + 1},
        {x + 1, y},
        {x + 1, y + 1}
      ]

      {:square, coordinates}
    end

    def new(:vbar, {x, y}) do
      {:vbar, for(i <- 0..3, do: {x, y + i})}
    end

    def move({type, coords}, :down) do
      new_coords = Enum.map(coords, fn {x, y} -> {x, y - 1} end)

      {type, new_coords}
    end

    def move(rock, :left), do: move_horizontally(rock, -1)
    def move(rock, :right), do: move_horizontally(rock, 1)

    defp move_horizontally({type, coords}, dx) do
      new_coords = Enum.map(coords, fn {x, y} -> {x + dx, y} end)

      {type, new_coords}
    end
  end

  defmodule Chamber do
    defstruct [:coordinates, :max_h, :next_rock]

    def new do
      %__MODULE__{coordinates: MapSet.new(), max_h: -1, next_rock: :hbar}
    end

    def rock_tower_height(chamber) do
      chamber.max_h + 1
    end

    def new_starting_coordinate(chamber) do
      {2, rock_tower_height(chamber) + 3}
    end

    def next_rock(chamber) do
      type = chamber.next_rock
      rock = Rock.new(type, new_starting_coordinate(chamber))

      new_chamber = struct!(chamber, next_rock: next(chamber.next_rock))

      {new_chamber, rock}
    end

    def place(chamber, {_type, coordinates}) do
      new_coordinates = MapSet.union(chamber.coordinates, MapSet.new(coordinates))
      heights = Enum.map(coordinates, &elem(&1, 1))
      heights = [chamber.max_h | heights]

      struct!(chamber, coordinates: new_coordinates, max_h: Enum.max(heights))
    end

    def horizontal_collision?(chamber, {_type, coordinates}) do
      cave_wall? = Enum.any?(coordinates, fn {x, _y} -> x == -1 or x == 7 end)

      cave_wall? or not MapSet.disjoint?(chamber.coordinates, MapSet.new(coordinates))
    end

    def vertical_collision?(chamber, {_type, coordinates}) do
      cave_floor? = Enum.any?(coordinates, fn {_x, y} -> y == -1 end)

      cave_floor? or not MapSet.disjoint?(chamber.coordinates, MapSet.new(coordinates))
    end

    defp next(:hbar), do: :plus
    defp next(:plus), do: :rev_L
    defp next(:rev_L), do: :vbar
    defp next(:vbar), do: :square
    defp next(:square), do: :hbar
  end

  def parse_jet_patterns(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(fn
      ">" -> :right
      "<" -> :left
    end)
  end

  def place_rocks(jets, rocks) do
    chamber = Chamber.new()

    do_place_rocks(chamber, jets, jets, rocks)
  end

  defp do_place_rocks(chamber, _all_jets, _jets, 0), do: chamber

  defp do_place_rocks(chamber, all_jets, jets, rocks) do
    {new_chamber, rock} = Chamber.next_rock(chamber)

    {new_chamber, new_jets} = fall(rock, new_chamber, all_jets, jets)

    do_place_rocks(new_chamber, all_jets, new_jets, rocks - 1)
  end

  defp fall(rock, chamber, all_jets, jets)

  defp fall(rock, chamber, all_jets, []), do: fall(rock, chamber, all_jets, all_jets)

  defp fall(rock, chamber, all_jets, [jet | rest]) do
    case move(rock, jet, chamber) do
      {:ok, new_rock} ->
        fall(new_rock, chamber, all_jets, rest)

      {:stopped, at_rest} ->
        {Chamber.place(chamber, at_rest), rest}
    end
  end

  defp move(rock, direction, chamber) do
    jet_moved = Rock.move(rock, direction)
    jet_moved = if Chamber.horizontal_collision?(chamber, jet_moved), do: rock, else: jet_moved

    fallen = Rock.move(jet_moved, :down)

    if Chamber.vertical_collision?(chamber, fallen) do
      {:stopped, jet_moved}
    else
      {:ok, fallen}
    end
  end

  def draw(chamber, moving \\ MapSet.new) do
    height = Enum.max([Chamber.rock_tower_height(chamber) | Enum.map(moving, &elem(&1, 1))])

    height..0//-1
    |> Enum.map(fn y ->
      Enum.map(0..6, fn x ->
        cond do
          MapSet.member?(chamber.coordinates, {x, y}) -> "#"
          MapSet.member?(moving, {x, y}) -> "@"
          true -> "."
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end
end
