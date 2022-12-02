defmodule AdventOfCode2022Elixir.Day02RockPaperScissorsTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day02RockPaperScissors

  test "score/1" do
    assert score("""
    A Y
    B X
    C Z
    """) == 15
  end

  test "score_round/2" do
    assert score_round(:paper, :win) == 8
    assert score_round(:rock, :loss) == 1
    assert score_round(:scissors, :draw) == 6
  end

  test "part 1" do
    assert score(Input.raw(2)) == 13675
  end
end
