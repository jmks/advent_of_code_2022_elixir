defmodule AdventOfCode2022Elixir.Day10CathodeRayTubeTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day10CathodeRayTube

  alias AdventOfCode2022Elixir.Day10CathodeRayTube.RegisterX

  test "the truth" do
    assert true
  end

  test "parse/1" do
    assert parse("""
           noop
           addx 3
           addx -5
           """) == [
             :noop,
             {:addx, 3},
             {:addx, -5}
           ]
  end

  describe "Register X" do
    import RegisterX

    test "noop done after 1 cycle" do
      x = new([:noop]) |> cycle()

      assert x.instructions == []
      assert x.value == 1
    end

    test "addx done after 2 cycles" do
      x = new([{:addx, 3}]) |> cycle()

      assert x.instructions == []
      assert x.value == 1

      x = cycle(x)

      assert x.instructions == []
      assert x.value == 4
    end

    test "multiple cycles" do
      x = new([:noop, {:addx, -4}]) |> cycle(3)

      assert x.value == -3
    end
  end

  test "signal_strength/1" do
    assert signal_strength(Input.raw("10.example")) == 13140
    assert signal_strength(Input.raw(10)) == 12
  end
end
