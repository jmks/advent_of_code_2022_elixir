defmodule AdventOfCode2022Elixir.Day16ProboscideaVolcanium do
  @moduledoc """
  --- Day 16: Proboscidea Volcanium ---

  The sensors have led you to the origin of the distress signal: yet another handheld device, just like the one the Elves gave you. However, you don't see any Elves around; instead, the device is surrounded by elephants! They must have gotten lost in these tunnels, and one of the elephants apparently figured out how to turn on the distress signal.

  The ground rumbles again, much stronger this time. What kind of cave is this, exactly? You scan the cave with your handheld device; it reports mostly igneous rock, some ash, pockets of pressurized gas, magma... this isn't just a cave, it's a volcano!

  You need to get the elephants out of here, quickly. Your device estimates that you have 30 minutes before the volcano erupts, so you don't have time to go back out the way you came in.

  You scan the cave for other options and discover a network of pipes and pressure-release valves. You aren't sure how such a system got into a volcano, but you don't have time to complain; your devie produces a report (your puzzle input) of each valve's flow rate if it were opened (in pressure per minute) and the tunnels you could use to move between the valves.

  There's even a valve in the room you and the elephants are currently standing in labeled AA. You estimate it will take you one minute to open a single valve and one minute to follow any tunnel from one valve to another. What is the most pressure you could release?

  For example, suppose you had the following scan output:

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

  All of the valves begin closed. You start at valve AA, but it must be damaged or jammed or something: its flow rate is 0, so there's no point in opening it. However, you could spend one minute moving to valve BB and another minute opening it; doing so would release pressure during the remaining 28 minutes at a flow rate of 13, a total eventual pressure release of 28 * 13 = 364. Then, you could spend your third minute moving to valve CC and your fourth minute opening it, providing an additional 26 minutes of eventual pressure release at a flow rate of 2, or 52 total pressure released by valve CC.

  Making your way through the tunnels like this, you could probably open many or all of the valves by the time 30 minutes have elapsed. However, you need to release as much pressure as possible, so you'll need to be methodical. Instead, consider this approach:

  == Minute 1 ==
  No valves are open.
  You move to valve DD.

  == Minute 2 ==
  No valves are open.
  You open valve DD.

  == Minute 3 ==
  Valve DD is open, releasing 20 pressure.
  You move to valve CC.

  == Minute 4 ==
  Valve DD is open, releasing 20 pressure.
  You move to valve BB.

  == Minute 5 ==
  Valve DD is open, releasing 20 pressure.
  You open valve BB.

  == Minute 6 ==
  Valves BB and DD are open, releasing 33 pressure.
  You move to valve AA.

  == Minute 7 ==
  Valves BB and DD are open, releasing 33 pressure.
  You move to valve II.

  == Minute 8 ==
  Valves BB and DD are open, releasing 33 pressure.
  You move to valve JJ.

  == Minute 9 ==
  Valves BB and DD are open, releasing 33 pressure.
  You open valve JJ.

  == Minute 10 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve II.

  == Minute 11 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve AA.

  == Minute 12 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve DD.

  == Minute 13 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve EE.

  == Minute 14 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve FF.

  == Minute 15 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve GG.

  == Minute 16 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You move to valve HH.

  == Minute 17 ==
  Valves BB, DD, and JJ are open, releasing 54 pressure.
  You open valve HH.

  == Minute 18 ==
  Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
  You move to valve GG.

  == Minute 19 ==
  Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
  You move to valve FF.

  == Minute 20 ==
  Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
  You move to valve EE.

  == Minute 21 ==
  Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
  You open valve EE.

  == Minute 22 ==
  Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
  You move to valve DD.

  == Minute 23 ==
  Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
  You move to valve CC.

  == Minute 24 ==
  Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
  You open valve CC.

  == Minute 25 ==
  Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  == Minute 26 ==
  Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  == Minute 27 ==
  Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  == Minute 28 ==
  Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  == Minute 29 ==
  Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  == Minute 30 ==
  Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  This approach lets you release the most pressure possible in 30 minutes with this valve layout, 1651.

  Work out the steps to release the most pressure in 30 minutes. What is the most pressure you can release?
  """
  defmodule Valve do
    defstruct [:name, :rate, :tunnels]

    def new(name, rate, tunnels) do
      %__MODULE__{
        name: name,
        rate: rate,
        tunnels: tunnels
      }
    end
  end

  defmodule State do
    defstruct [
      :graph,
      :current_valve,
      :initial_minutes,
      :minutes_remaining,
      :opened,
      :history,
      :pressure_released,
      :pending_actions
    ]

    def new(graph, initial_valve \\ "AA", minutes \\ 30) do
      %__MODULE__{
        graph: graph,
        current_valve: Map.fetch!(graph, initial_valve),
        initial_minutes: minutes,
        minutes_remaining: minutes,
        opened: MapSet.new(),
        history: [],
        pressure_released: 0,
        pending_actions: []
      }
    end

    def current_open?(state) do
      MapSet.member?(state.opened, state.current_valve.name)
    end

    def perform_action(state, {:move, valve}) do
      state
      |> tick()
      |> update_pressure()
      |> move(valve)
    end

    def perform_action(state, {:open, valve}) do
      state
      |> tick()
      |> update_pressure()
      |> open(valve)
    end

    def perform_action(state, :noop) do
      state
      |> tick()
      |> update_pressure()
    end

    def perform_action(state, {:goto, valve}) do
      path = shortest_path(state.graph, state.current_valve.name, valve)
      actions = Enum.map(tl(path), fn v -> {:move, v} end) ++ [{:open, valve}]

      state
      |> struct!(pending_actions: actions)
      |> perform_pending_action()
    end

    def perform_pending_action(%{pending_actions: [action | pending]} = state) do
      state
      |> struct!(pending_actions: pending)
      |> perform_action(action)
    end

    # Randomly moving around is super-inefficient.
    # Be more goal-oriented: move towards an closed valves to open them.
    def next_actions(state) do
      # All valves open; nothing to do
      if MapSet.size(closed_valves(state)) == 0 do
        [:noop]
      else
        state
        |> closed_valves()
        |> Enum.map(fn valve ->
          cond do
            valve == state.current_valve.name ->
              {:open, valve}

            true ->
              {:goto, valve}
          end
        end)
      end
    end

    # Set of closed valves, excluding those that should not be opened (i.e. rate = 0)
    def closed_valves(state) do
      state.graph
      |> Enum.filter(fn {_name, valve} -> valve.rate > 0 end)
      |> Enum.map(fn {name, _valve} -> name end)
      |> MapSet.new()
      |> MapSet.difference(state.opened)
    end

    def pending_action?(state) do
      length(state.pending_actions) > 0
    end

    defp update_pressure(state) do
      # TODO: Could aggregate this into per minute total
      new_pressure =
        Enum.map(state.opened, fn valve ->
          v = Map.fetch!(state.graph, valve)
          v.rate
        end)
        |> Enum.sum()

      historical_record = {:pressure_released, new_pressure, state.initial_minutes - state.minutes_remaining}

      struct!(state,
        pressure_released: state.pressure_released + new_pressure,
        history: [historical_record | state.history]
      )
    end

    defp tick(state) do
      struct!(state, minutes_remaining: state.minutes_remaining - 1)
    end

    defp move(state, name) do
      valve = Map.fetch!(state.graph, name)

      struct!(state,
        current_valve: valve,
        history: [{:move, name} | state.history]
      )
    end

    defp open(state, valve) do
      struct!(state,
        opened: MapSet.put(state.opened, valve),
        history: [{:open, valve} | state.history]
      )
    end

    defp shortest_path(graph, start, destination) do
      q = :queue.new()
      q = :queue.in([start], q)

      do_shortest_path(graph, destination, q)
    end

    defp do_shortest_path(graph, destination, paths) do
      {{:value, path}, rest} = :queue.out(paths)

      if hd(path) == destination do
        Enum.reverse(path)
      else
        valve = Map.fetch!(graph, hd(path))
        # TODO: maybe slow for long paths?
        next = Enum.filter(valve.tunnels, fn valve -> valve not in path end)

        new_paths =
          next
          |> Enum.map(fn valve -> [valve | path] end)
          |> Enum.reduce(rest, &:queue.in/2)

        do_shortest_path(graph, destination, new_paths)
      end
    end
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_valve/1)
    |> Enum.map(fn v -> {v.name, v} end)
    |> Enum.into(%{})
  end

  def maximum_pressure_released(input) do
    state = State.new(parse(input), "AA")
    best = {0, nil}

    do_maximum_pressure_released([state], best)
  end

  defp parse_valve(line) do
    [_line, valve, rate, valve_list] =
      Regex.run(~r/^Valve ([A-Z]+).* rate=([0-9]+).* valves? (.*)$/, line)

    tunnels = String.split(valve_list, ", ", trim: true)

    Valve.new(valve, String.to_integer(rate), tunnels)
  end

  defp do_maximum_pressure_released([], {total, _history}), do: total

  defp do_maximum_pressure_released(
         [%State{minutes_remaining: 0} = state | rest],
         {total, _} = best
       ) do
    if state.pressure_released > total do
      do_maximum_pressure_released(
        rest,
        {state.pressure_released, Enum.reverse(state.history)}
      )
    else
      do_maximum_pressure_released(rest, best)
    end
  end

  defp do_maximum_pressure_released([state | rest], {high, _history} = best) do
    if State.pending_action?(state) do
      do_maximum_pressure_released([State.perform_pending_action(state) | rest], best)
    else
      actions = State.next_actions(state)

      new_states =
        actions
        |> Enum.map(&State.perform_action(state, &1))
        |> Enum.filter(fn state -> best_possible(state) > high end)

      do_maximum_pressure_released(new_states ++ rest, best)
    end
  end

  # To prune results, we'll assume at this timestamp, all closed valves are magically opened.
  # With all the valves opened, we can drop this path if it can not exceed the best-so-far.
  defp best_possible(state) do
    total_rate = Enum.reduce(state.graph, 0, fn {_name, valve}, sum -> valve.rate + sum end)

    state.pressure_released + state.minutes_remaining * total_rate
  end
end
