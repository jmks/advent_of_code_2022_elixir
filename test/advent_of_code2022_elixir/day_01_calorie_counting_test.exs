defmodule AdventOfCode2022Elixir.Day01CalorieCountingTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day01CalorieCounting

  @example """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "fourth elf carries the most calories" do
    assert parse(@example) == 24000
  end

  test "part 1" do
    assert parse(Input.raw(1)) == 69310
  end
end
