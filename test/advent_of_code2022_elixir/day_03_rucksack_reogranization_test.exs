defmodule AdventOfCode2022Elixir.Day03RucksackReogranizationTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day03RucksackReogranization

  @example """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """ |> String.split("\n", trim: true)

  test "sum_of_prioriries" do
    assert sum_of_priorities(@example) == 157
    assert sum_of_priorities(Input.strings(3)) == 7997
  end

  test "sum_of_badge_priorities" do
    assert sum_of_badge_priorities(@example) == 70
    assert sum_of_badge_priorities(Input.strings(3)) == 2545
  end
end
