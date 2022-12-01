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
    assert most_calories(@example) == 24000
    assert most_calories(Input.raw(1)) == 69310
  end

  test "sum of calories of top three calorie carrying elves" do
    assert top_n_sum(@example, 3) == 45000
    assert top_n_sum(Input.raw(1), 3) == 206104
  end
end
