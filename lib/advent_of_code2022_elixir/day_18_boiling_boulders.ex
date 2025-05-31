defmodule AdventOfCode2022Elixir.Day18BoilingBoulders do
  @moduledoc """
  --- Day 18: Boiling Boulders ---

  You and the elephants finally reach fresh air. You've emerged near the base of a large volcano that seems to be actively erupting! Fortunately, the lava seems to be flowing away from you and toward the ocean.

  Bits of lava are still being ejected toward you, so you're sheltering in the cavern exit a little longer. Outside the cave, you can see the lava landing in a pond and hear it loudly hissing as it solidifies.

  Depending on the specific compounds in the lava and speed at which it cools, it might be forming obsidian! The cooling rate should be based on the surface area of the lava droplets, so you take a quick scan of a droplet as it flies past you (your puzzle input).

  Because of how quickly the lava is moving, the scan isn't very good; its resolution is quite low and, as a result, it approximates the shape of the lava droplet with 1x1x1 cubes on a 3D grid, each given as its x,y,z position.

  To approximate the surface area, count the number of sides of each cube that arenot immediately connected to another cube. So, if your scan were only two adjacent cubes like 1,1,1 and 2,1,1, each cube would have a single side covered and five sides exposed, a total surface area of 10 sides.

  Here's a larger example:

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

  In the above example, after counting up all the sides that aren't connected to another cube, the total surface area is 64.

  What is the surface area of your scanned lava droplet?

  --- Part Two ---

  Something seems off about your calculation. The cooling rate depends on exterior surface area, but your calculation also included the surface area of air pockets trapped in the lava droplet.

  Instead, consider only cube sides that could be reached by the water and steam as the lava droplet tumbles into the pond. The steam will expand to reach as much as possible, completely displacing any air on the outside of the lava droplet but never expanding diagonally.

  In the larger example above, exactly one cube of air is trapped within the lava droplet (at 2,2,5), so the exterior surface area of the lava droplet is 58.

  What is the exterior surface area of your scanned lava droplet?
  """
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def sides(input) do
    lava = parse(input)

    count_sides(lava, MapSet.new(lava))
  end

  def exposed_sides(input) do
    lava = parse(input)

    count_exposed_sides(lava, MapSet.new(lava))
  end

  defp count_sides(lavas, set) do
    lavas
    |> Enum.map(fn lava ->
      adjacent = MapSet.new(adjacent_faces(lava))
      count = MapSet.intersection(set, adjacent) |> MapSet.size()

      6 - count
    end)
    |> Enum.sum()
  end

  defp adjacent_faces({x, y, z}) do
    [
      {x + 1, y, z},
      {x - 1, y, z},
      {x, y + 1, z},
      {x, y - 1, z},
      {x, y, z + 1},
      {x, y, z - 1}
    ]
  end

  def count_exposed_sides(lavas, set) do
    {minx, maxx} = lavas |> Enum.map(&project(:x, &1)) |> Enum.min_max()
    {miny, maxy} = lavas |> Enum.map(&project(:y, &1)) |> Enum.min_max()
    {minz, maxz} = lavas |> Enum.map(&project(:z, &1)) |> Enum.min_max()

    min = {minx, miny, minz}
    max = {maxx, maxy, maxz}

    lavas
    |> Enum.map(fn lava ->
      exposed = Enum.count(vectors(), &exposed?(&1, add_vector(&1, lava), set, min, max))

      6 - exposed
    end)
    |> Enum.sum()
  end

  defp project(:x, {x, _, _}), do: x
  defp project(:y, {_, y, _}), do: y
  defp project(:z, {_, _, z}), do: z

  defp vectors do
    [
      {:x, 1},
      {:x, -1},
      {:y, 1},
      {:y, -1},
      {:z, 1},
      {:z, -1}
    ]
  end

  defp exposed?({dir, _delta} = vector, {x, y, z} = coordinate, set, min, max) do
    value = project(dir, coordinate)

    cond do
      value < project(dir, min) or value > project(dir, max) -> true
      {x, y, z} in set -> false
      true -> exposed?(vector, add_vector(vector, coordinate), set, min, max)
    end
  end

  defp add_vector({:x, delta}, {x, y, z}), do: {x + delta, y, z}
  defp add_vector({:y, delta}, {x, y, z}), do: {x, y +  delta, z}
  defp add_vector({:z, delta}, {x, y, z}), do: {x, y, z + delta}
end
