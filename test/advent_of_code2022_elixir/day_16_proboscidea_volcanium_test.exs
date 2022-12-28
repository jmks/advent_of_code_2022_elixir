defmodule AdventOfCode2022Elixir.Day16ProboscideaVolcaniumTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day16ProboscideaVolcanium

  alias AdventOfCode2022Elixir.Day16ProboscideaVolcanium.{State, Valve}

  @example """
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """

  test "parse/1" do
    parsed = parse(@example)

    assert parsed["AA"] == Valve.new("AA", 0, ["DD", "II", "BB"])
    assert parsed["BB"] == Valve.new("BB", 13, ["CC", "AA"])
    assert parsed["CC"] == Valve.new("CC", 2, ["DD", "BB"])
  end

  describe "State" do
    test "perform_action/2 goto far tunnel creates pending actions" do
      state = State.new(parse(@example))

      refute State.pending_action?(state)

      state = State.perform_action(state, {:goto, "JJ"})

      assert State.pending_action?(state)

      assert state.pending_actions == [
               # This move is done by perform_action
               # {:move, "II"},
               {:move, "JJ"},
               {:open, "JJ"}
             ]
    end

    test "tally pressure released" do
      state =
        State.new(parse(@example))
        |> State.perform_action({:move, "DD"})
        |> State.perform_action({:open, "DD"})

      assert state.opened == MapSet.new(["DD"])
      assert state.minutes_remaining == 28
      assert state.pressure_released == 0

      state = State.perform_action(state, {:move, "CC"})

      assert state.minutes_remaining == 27
      assert state.pressure_released == 20

      state =
        state
        |> State.perform_action({:move, "BB"})
        |> State.perform_action({:open, "BB"})
        |> State.perform_action({:move, "AA"})
        |> State.perform_action({:move, "II"})

      assert state.minutes_remaining == 23
      assert state.pressure_released == 126

      state =
        state
        |> State.perform_action({:move, "JJ"})
        |> State.perform_action({:open, "JJ"})
        |> State.perform_action({:move, "II"})
        |> State.perform_action({:move, "AA"})
        |> State.perform_action({:move, "DD"})
        |> State.perform_action({:move, "EE"})
        |> State.perform_action({:move, "FF"})
        |> State.perform_action({:move, "GG"})
        |> State.perform_action({:move, "HH"})
        |> State.perform_action({:open, "HH"})
        |> State.perform_action({:move, "GG"})
        |> State.perform_action({:move, "FF"})
        |> State.perform_action({:move, "EE"})
        |> State.perform_action({:open, "EE"})
        |> State.perform_action({:move, "DD"})
        |> State.perform_action({:move, "CC"})
        |> State.perform_action({:open, "CC"})
        |> State.perform_action(:noop)
        |> State.perform_action(:noop)
        |> State.perform_action(:noop)
        |> State.perform_action(:noop)
        |> State.perform_action(:noop)
        |> State.perform_action(:noop)

      assert state.minutes_remaining == 0
      assert state.pressure_released == 1651
    end

    test "closed_valves/1" do
      state = State.new(parse(@example))

      assert State.closed_valves(state) == MapSet.new(["BB", "CC", "DD", "EE", "HH", "JJ"])
    end

    test "next_actions/1 to move or goto closed valves" do
      state = State.new(parse(@example))

      assert MapSet.new(State.next_actions(state)) ==
               MapSet.new([
                 {:goto, "BB"},
                 {:goto, "CC"},
                 {:goto, "DD"},
                 {:goto, "EE"},
                 {:goto, "HH"},
                 {:goto, "JJ"}
               ])
    end

    test "next_actions/1 with all valves open" do
      state = State.new(parse(@example))
      state = struct!(state, opened: MapSet.new(State.closed_valves(state)))

      assert State.next_actions(state) == [:noop]
    end
  end

  test "maximum_pressure_released/2" do
    assert maximum_pressure_released(@example) == 1651
  end

  describe "theoretical_best/1" do
    setup do
      graph = %{
        "AA" => Valve.new("AA", 1, ["BB"]),
        "BB" => Valve.new("BB", 2, ["AA"])
      }

      state = State.new(graph)

      %{state: state}
    end

    test "no open valves", %{state: state} do
      assert theoretical_best(state) == (1 + 2) * 30
    end

    test "with open valve", %{state: state} do
      state = State.perform_action(state, {:open, "AA"})
      state = Enum.reduce(1..9, state, fn _, s -> State.perform_action(s, :noop) end)

      assert theoretical_best(state) == 9 + 20 * (1 + 2)
    end
  end

  describe "expected_value/1" do
    setup do
      graph = %{
        "AA" => Valve.new("AA", 1, ["BB"]),
        "BB" => Valve.new("BB", 2, ["AA"])
      }

      state = State.new(graph)

      %{state: state}
    end

    test "ev of noop is 0", %{state: state} do
      assert expected_value(state, :noop) == 0
    end

    test "ev of a move is 0", %{state: state} do
      assert expected_value(state, {:move, "BB"}) == 0
    end

    test "ev of opening a valve is the total pressure gained divided over minutes to perform action", %{state: state} do
      assert expected_value(state, {:open, "AA"}) == 1 * 29
      assert expected_value(state, {:goto, "BB"}) == (2 * 28) / 2
      assert state |> State.perform_action({:open, "AA"}) |> expected_value({:goto, "BB"}) == (2 * 26) / 2
    end
  end

  @tag :slow
  test "part 1" do
    assert maximum_pressure_released(Input.raw(16)) == 1659
  end
end
