defmodule AdventOfCode2022Elixir.Day10CathodeRayTube do
  @moduledoc """
  --- Day 10: Cathode-Ray Tube ---

  You avoid the ropes, plunge into the river, and swim to shore.

  The Elves yell something about meeting back up with them upriver, but the river is too loud to tell exactly what they're saying. They finish crossing the bridge and disappear from view.

  Situations like this must be why the Elves prioritized getting the communication system on your handheld device working. You pull it out of your pack, but the amount of water slowly draining from a big crack in its screen tells you it probably won't be of much immediate use.

  Unless, that is, you can design a replacement for the device's video system! It seems to be some kind of cathode-ray tube screen and simple CPU that are both driven by a precise clock circuit. The clock circuit ticks at a constant rate; each tick is called a cycle.

  Start by figuring out the signal being sent by the CPU. The CPU has a single register, X, which starts with the value 1. It supports only two instructions:

    addx V takes two cycles to complee. After two cycles, the X register is increased by the value V. (V can be negative.)
    noop takes one cycle to complete. It has no other effect.

  The CPU uses these instructions in a program (your puzzle input) to, somehow, tell the screen what to draw.

  Consider the following small program:

  noop
  addx 3
  addx -5

  Execution of this program proceeds as follows:

    At the start of the first cycle, the noop instruction begins execution. During the first cycle, X is 1. After the first cycle, the noop instruction finishes execution, doing nothing.
    At the start of the second cycle, the addx 3 instruction begins execution. During the second cycle, X is still 1.
    During the third cycle, X is still 1. After the third cycle, the addx 3 instruction finishes execution, setting X to 4.
    At the start of the fourth cycle, the addx -5 instruction begins execution. During the fourth cycle, X is still 4.
    During the fifth cycle, X is still 4. After the fifth cycle, the addx -5 instruction finishes execution, setting X to -1.

  Maybe you can learn something by looking at the value of the X register throughout execution. For now, consider the signal strength (the cycle number multiplied by the value of the X register) during the 20th cycle and every 40 cycles after that (that is, during the 20th, 60th, 100th, 140th, 180th, and 220th cycles).

  For example, consider this larger program:

  addx 15
  addx -11
  addx 6
  addx -3
  addx 5
  addx -1
  addx -8
  addx 13
  addx 4
  noop
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx -35
  addx 1
  addx 24
  addx -19
  addx 1
  addx 16
  addx -11
  noop
  noop
  addx 21
  addx -15
  noop
  noop
  addx -3
  addx 9
  addx 1
  addx -3
  addx 8
  addx 1
  addx 5
  noop
  noop
  noop
  noop
  noop
  addx -36
  noop
  addx 1
  addx 7
  noop
  noop
  noop
  addx 2
  addx 6
  noop
  noop
  noop
  noop
  noop
  addx 1
  noop
  noop
  addx 7
  addx 1
  noop
  addx -13
  addx 13
  addx 7
  noop
  addx 1
  addx -33
  noop
  noop
  noop
  addx 2
  noop
  noop
  noop
  addx 8
  noop
  addx -1
  addx 2
  addx 1
  noop
  addx 17
  addx -9
  addx 1
  addx 1
  addx -3
  addx 11
  noop
  noop
  addx 1
  noop
  addx 1
  noop
  noop
  addx -13
  addx -19
  addx 1
  addx 3
  addx 26
  addx -30
  addx 12
  addx -1
  addx 3
  addx 1
  noop
  noop
  noop
  addx -9
  addx 18
  addx 1
  addx 2
  noop
  noop
  addx 9
  noop
  noop
  noop
  addx -1
  addx 2
  addx -37
  addx 1
  addx 3
  noop
  addx 15
  addx -21
  addx 22
  addx -6
  addx 1
  noop
  addx 2
  addx 1
  noop
  addx -10
  noop
  noop
  addx 20
  addx 1
  addx 2
  addx 2
  addx -6
  addx -11
  noop
  noop
  noop

  The interesting signal strengths can be determined as follows:

    During the 20th cycle, register X has the value 21, so the signal strength is 20 * 21 = 420. (The 20th cycle occurs in the middle of the second addx -1, so the value of register X is the starting value, 1, plus all of the other addx values up to that point: 1 + 15 - 11 + 6 - 3 + 5 - 1 - 8 + 13 + 4 = 21.)
    During the 60th cycle, register X has the value 19, so the signal strength is 60 * 19 = 1140.
    During the 100th cycle, register X has the value 18, so the signal strength is 100 * 18 = 1800.
    During the 140th cycle, register X has the value 21, so the signal strength is 140 * 21 = 2940.
    During the 180th cycle, register X has the value 16, so the signal strength is 180 * 16 = 2880.
    During the 220th cycle, register X has the value 18, so the signal strength is 220 * 18 = 3960.

  The sum of these signal strengths is 13140.

  Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six signal strengths?
  """
  defmodule RegisterX do
    defstruct [:value, :instructions, :processing, :history]

    def new(instructions, value \\ 1) do
      %__MODULE__{
        value: value,
        instructions: instructions,
        processing: nil,
        history: []
      }
    end

    def cycle(reg, cycles) do
      Enum.reduce(1..cycles, reg, fn _, reg -> cycle(reg) end)
    end

    def cycle(reg) do
      case reg.processing do
        {:addx, value, 1} ->
          new_value = reg.value + value
          new_history = [{:second_addx, reg.processing, new_value} | reg.history]

          %{reg | value: new_value, processing: nil, history: new_history}

        nil ->
          process_instruction(reg)
      end
    end

    defp process_instruction(%{instructions: []} = reg) do
      %{reg | history: [{:no_instruction, reg.value} | reg.history]}
    end

    defp process_instruction(%{instructions: [instruction | rest]} = reg) do
      case instruction do
        :noop ->
          %{reg | instructions: rest, history: [{:noop, :noop, reg.value} | reg.history]}

        {:addx, value} ->
          new_processing = {:addx, value, 1}
          new_history = [{:first_addx, new_processing, reg.value} | reg.history]

          %{reg | processing: new_processing, instructions: rest, history: new_history}
      end
    end
  end

  def signal_strength(input) do
    reg = RegisterX.new(parse(input))
    cycles = [20, 40, 40, 40, 40, 40]
    cumulative_cycles = [20, 60, 100, 140, 180, 220]

    cycle_signals(reg, cycles, [])
    |> Enum.zip(cumulative_cycles)
    |> Enum.map(fn {{_, reg}, cycle} -> cycle * reg end)
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction("noop"), do: :noop
  defp parse_instruction("addx " <> value), do: {:addx, String.to_integer(value)}

  defp cycle_signals(_reg, [], signals), do: Enum.reverse(signals)

  defp cycle_signals(reg, [cycle | cycles], signals) do
    # RegisterX.cycle computes to the end of the cycle
    # So, "during" the Nth cycle, is after the previous one.
    new_reg = RegisterX.cycle(reg, cycle - 1)

    cycle_signals(RegisterX.cycle(new_reg), cycles, [{cycle, new_reg.value} | signals])
  end
end
