defmodule AdventOfCode2022Elixir.Day14RegolithReservoir do
  @moduledoc """
  --- Day 14: Regolith Reservoir ---

  The distress signal leads you to a giant waterfall! Actually, hang on - the signal seems like it's coming from the waterfall itself, and that doesn't make any sense. However, you do notice a little path that leads behind the waterfall.

  Correction: the distress signal leads you behind a giant waterfall! There seems to be a large cave system here, and the signal definitely leads further inside.

  As you begin to make your way deeper underground, you feel the ground rumble for a moment. Sand begins pouring into the cave! If you don't quickly figure out where the sand is going, you could quickly become trapped!

  Fortunately, your familiarity with analyzing the path of falling material will come in handy here. You scan a two-dimensional vertical slice of the cave above you (your puzzle input) and discover that it is mostly air with structures made of rock.

  Your scan traces the path of each solid rock structure and reports the x,y coordinates that form the shape of the path, whre x represents distance to the right and y represents distance down. Each path appears as a single line of text in your scan. After the first point of each path, each point indicates the end of a straight horizontal or vertical line to be drawn from the previous point. For example:

  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9

  This scan means that there are two paths of rock; the first path consists of two straight lines, and the second path consists of three straight lines. (Specifically, the first path consists of a line of rock from 498,4 through 498,6 and another line of rock from 498,6 through 496,6.)

  The sand is pouring into the cave from point 500,0.

  Drawing rock as #, air as ., and the source of the sand as +, this becomes:

    4     5  5
    9     0  0
    4     0  3
  0 ......+...
  1 ..........
  2 ..........
  3 ..........
  4 ....#...##
  5 ....#...#.
  6 ..###...#.
  7 ........#.
  8 ........#.
  9 #########.

  Sand is produced one unit at a time, and the next unit of sand is not produced until the previous unit of sand comes to rest. A unit of sand is large enough to fill one tile of air in your scan.

  A unit of sand always falls down one step if possible. If the tile immediately below is blocked (by rock or sand), the unit of sand attempts to instead move diagonally one step down and to the left. If that tile is blocked, the unit of sand attempts to instead move diagonally one step down and to the right. Sand keeps moving as long as it is able to do so, at each step trying to move down, then down-left, then down-right. If all three possible destinations are blocked, the unit of sand comes to rest and no longer moves, at which point the next unit of sand is created back at the source.

  So, drawing sand that has come to rest as o, the first unit of sand simply falls straight down and then stops:

  ......+...
  ..........
  ..........
  ..........
  ....#...##
  ....#...#.
  ..###...#.
  ........#.
  ......o.#.
  #########.

  The second unit of sand then falls straight down, lands on the first one, and then comes to rest to its left:

  ......+...
  ..........
  ..........
  ..........
  ....#...##
  ....#...#.
  ..###...#.
  ........#.
  .....oo.#.
  #########.

  After a total of five units of sand have come to rest, they form this pattern:

  ......+...
  ..........
  ..........
  ..........
  ....#...##
  ....#...#.
  ..###...#.
  ......o.#.
  ....oooo#.
  #########.

  After a total of 22 units of sand:

  ......+...
  ..........
  ......o...
  .....ooo..
  ....#ooo##
  ....#ooo#.
  ..###ooo#.
  ....oooo#.
  ...ooooo#.
  #########.

  Finally, only two more units of sand can possibly come to rest:

  ......+...
  ..........
  ......o...
  .....ooo..
  ....#ooo##
  ...o#ooo#.
  ..###ooo#.
  ....oooo#.
  .o.ooooo#.
  #########.

  Once all 24 units of sand shown above have come to rest, all further sand flows out the bottom, falling into the endless void. Just for fun, the path any new sand takes before falling forever is shown here with ~:

  .......+...
  .......~...
  ......~o...
  .....~ooo..
  ....~#ooo##
  ...~o#ooo#.
  ..~###ooo#.
  ..~..oooo#.
  .~o.ooooo#.
  ~#########.
  ~..........
  ~..........
  ~..........

  Using your scan, simulate the falling sand. How many units of sand come to rest before sand starts flowing into the abyss below?

  --- Part Two ---

  You realize you misread the scan. There isn't an endless void at the bottom of the scan - there's floor, and you're standing on it!

  You don't have time to scan the floor, so assume the floor is an infinite horizontal line with a y coordinate equal to two plus the highest y coordinate of any point in your scan.

  In the example above, the highest y coordinate of any point is 9, and so the floor is at y=11. (This is as if your scan contained one extra rock path like -infinity,11 -> infinity,11.) With the added floor, the example above now looks like this:

        ...........+........
        ....................
        ....................
        ....................
        .........#...##.....
        .........#...#......
        .......###...#......
        .............#......
        .............#......
        .....#########......
        ....................
  <-- etc #################### etc -->

  To find somewhere safe to stand, you'll need to simulate falling sand until a unit of snd comes to rest at 500,0, blocking the source entirely and stopping the flow of sand into the cave. In the example above, the situation finally looks like this after 93 units of sand come to rest:

  ............o............
  ...........ooo...........
  ..........ooooo..........
  .........ooooooo.........
  ........oo#ooo##o........
  .......ooo#ooo#ooo.......
  ......oo###ooo#oooo......
  .....oooo.oooo#ooooo.....
  ....oooooooooo#oooooo....
  ...ooo#########ooooooo...
  ..ooooo.......ooooooooo..
  #########################

  Using your scan, simulate the falling sand until the source of the sand becomes blocked. How many units of sand come to rest?
  """
  defmodule Cave do
    defstruct [:rocks, :sand, :deepest_rock]

    @source {500, 0}

    def parse(input) do
      rocks =
        input
        |> parse_segments()
        |> Enum.flat_map(&expand_segment/1)

      # To detect falling in a bottomless pit, we want to know
      # when given our X position, what is the deepest Y a rock
      # is at.
      #
      # If there is no rock that could catch our fall..........
      deepest_rock =
        rocks
        |> Enum.group_by(fn {x, _} -> x end)
        |> Enum.map(fn {x, ys} ->
          maxy = ys |> Enum.map(fn {_, y} -> y end) |> Enum.max()

          {x, maxy}
        end)
        |> Enum.into(%{})

      %__MODULE__{
        rocks: MapSet.new(rocks),
        sand: MapSet.new(),
        deepest_rock: deepest_rock
      }
    end

    def draw(cave) do
      coordinates = Enum.into(cave.rocks, []) ++ Enum.into(cave.sand, [])
      coordinates = [@source | coordinates]

      minmax_x = coordinates |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
      minmax_y = coordinates |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

      draw(cave, minmax_x, minmax_y)
    end

    # Strategies:
    #  :bottomless -> until a sand falls into the bottomless void
    #  :block_source -> until a sand comes to rest at the source coordinate
    def fill_with_sand(cave, strategy \\ :bottomless)

    def fill_with_sand(cave, :bottomless) do
      case place(cave, @source) do
        {:bottomless_void, _placement, new_cave} ->
          MapSet.size(new_cave.sand)

        {:placed, _placement, new_cave} ->
          fill_with_sand(new_cave)
      end
    end

    def fill_with_sand(cave, :block_source) do
      lowest_object = Enum.map(cave.deepest_rock, fn {_, y} -> y end) |> Enum.max()
      max_depth = lowest_object + 1

      case place(cave, @source, max_depth) do
        {:placed, @source, new_cave} ->
          MapSet.size(new_cave.sand)

        {:placed, _placement, new_cave} ->
          fill_with_sand(new_cave, :block_source)

        {:bottomless_void, placed, new_cave} ->
          IO.puts(":block_source reached a bottomless pit at #{inspect placed}")
          IO.puts(Cave.draw(new_cave))

          MapSet.size(new_cave.sand)
      end
    end

    defp parse_segments(input) do
      input
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn line ->
        line
        |> String.split(" -> ", trim: true)
        |> Enum.map(fn coord ->
          [x, y] =
            String.split(coord, ",", trim: true, parts: 2) |> Enum.map(&String.to_integer/1)

          {x, y}
        end)
        |> Enum.chunk_every(2, 1, :discard)
      end)
    end

    defp expand_segment([{x, y1}, {x, y2}]) do
      {ymin, ymax} = Enum.min_max([y1, y2])

      for y <- ymin..ymax, do: {x, y}
    end

    defp expand_segment([{x1, y}, {x2, y}]) do
      {xmin, xmax} = Enum.min_max([x1, x2])

      for x <- xmin..xmax, do: {x, y}
    end

    defp draw(cave, {minx, maxx}, {miny, maxy}) do
      for y <- miny..maxy, x <- minx..maxx do
        cond do
          {x, y} == @source -> "+"
          MapSet.member?(cave.rocks, {x, y}) -> "#"
          MapSet.member?(cave.sand, {x, y}) -> "o"
          true -> "."
        end
      end
      |> Enum.chunk_every(maxy - miny + 1)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("\n")
    end

    defp place(cave, position, max_depth \\ :infinity) do
      next_position = next_sand_step(cave, position)

      cond do
        next_position == :at_rest ->
          new_sand = MapSet.put(cave.sand, position)
          new_cave = %{cave | sand: new_sand}

          {:placed, position, new_cave}

        max_depth == :infinity and falling_into_bottomless_void?(cave, next_position) ->
          {:bottomless_void, next_position, cave}

        elem(next_position, 1) == max_depth ->
          new_sand = MapSet.put(cave.sand, next_position)
          new_cave = %{cave | sand: new_sand}

          {:placed, next_position, new_cave}

        true ->
          place(cave, next_position, max_depth)
      end
    end

    defp next_sand_step(cave, {x, y}) do
      [
        {x, y + 1},
        {x - 1, y + 1},
        {x + 1, y + 1}
      ]
      |> Enum.reject(fn coord ->
        MapSet.member?(cave.rocks, coord) or MapSet.member?(cave.sand, coord)
      end)
      |> List.first(:at_rest)
    end

    defp falling_into_bottomless_void?(cave, {x, y}) do
      y >= Map.get(cave.deepest_rock, x, -1)
    end
  end
end
