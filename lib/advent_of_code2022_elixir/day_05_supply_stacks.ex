defmodule AdventOfCode2022Elixir.Day05SupplyStacks do
  @moduledoc """
  --- Day 5: Supply Stacks ---

  The expedition can depart as soon as the final supplies have been unloaded from the ships. Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other crates, the crates need to be rearranged.

  The ship has a giant cargo crane capable of moving crates between stacks. To ensure none of the crates get crushed or fall over, the crane operator will rearrange them in a series of carefully-planned steps. After the crates are rearranged, the desired crates will be at the top of each stack.

  The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot to ask her which crate will end up where, and they want to be ready to unload them as soon as possible so they can embark.

  They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input). For example:

      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2

  In this example, there are three stacks of crates. Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top. Stack 2 contains three crates; from bottom to top, they are crates M, C, and D. Finally, stack 3 contains a single crate, P.

  Then, the rearrangement procedure is given. In each step of the procedure, a quantity of crates is moved from one stack to a different stack. In the first step of the above rearrangement procedure, one crate is moved from stack 2 to stack 1, resulting in this configuration:

  [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:

         [Z]
         [N]
     [C] [D]
     [M] [P]
  1   2   3

  Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time, crate C ends up below crate M:

          [Z]
          [N]
  [M]     [D]
  [C]     [P]
   1   2   3

  Finally, one crate is moved from stack 1 to stack 2:

          [Z]
          [N]
          [D]
  [C] [M] [P]
   1   2   3

  The Elves just need to know which crate will end up on top of each stack; in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3, so you should combine these together and give the Elves the message CMZ.

  After the rearrangement procedure completes, what crate ends up on top of each stack?


  --- Part Two ---

  As you watch the crane operator expertly rearrange the crates, you notice the process isn't following your prediction.

  Some mud was covering the writing on the side of the crane, and you quickly wipe it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

  The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra cup holder, and the ability to pick up and move multiple crates at once.

  Again considering the example above, the crates begin in the same configuration:

      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  Moving a single crate from stack 2 to stack 1 behaves the same as before:

  [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay in the same order, resulting in this new configuration:

         [D]
         [N]
     [C] [Z]
     [M] [P]
  1   2   3

  Next, as both crates are moved from stack 2 to stack 1, they retain ther order as well:

          [D]
          [N]
  [C]     [Z]
  [M]     [P]
   1   2   3

  Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:

          [D]
          [N]
          [Z]
  [M] [C] [P]
   1   2   3

  In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.

  Before the rearrangement process finishes, update your simulation so that the Elves know where they should stand to be ready to unload the final supplies. After the rearrangement procedure completes, what crate ends up on top of each stack?
  """

  alias AdventOfCode2022Elixir.Stack

  def parse(input) do
    strings = String.split(input, "\n")

    setup = Enum.take_while(strings, &(String.length(&1) > 0))
    moves = Enum.drop(strings, length(setup) + 1)

    {parse_stacks(setup), parse_moves(moves)}
  end

  def apply_moves({stacks_list, moves}, order \\ :stack) do
    stacks =
      for {stack, offset} <- Enum.with_index(stacks_list, 1), into: %{}, do: {offset, stack}

    applied =
      Enum.reduce(moves, stacks, fn [count, source, destination], stacks ->
        src = Map.fetch!(stacks, source)
        {popped, new_src} = Stack.pop(src, count)

        new_dest =
          stacks
          |> Map.fetch!(destination)
          |> Stack.push_many(popped, order)

        stacks
        |> Map.put(source, new_src)
        |> Map.put(destination, new_dest)
      end)

    for i <- 1..length(stacks_list), do: Map.fetch!(applied, i)
  end

  def top_of_stacks(parsed, :crane_mover_9000) do
    do_top_of_stacks(parsed, :stack)
  end

  def top_of_stacks(parsed, :crane_mover_9001) do
    do_top_of_stacks(parsed, :preserve)
  end

  defp do_top_of_stacks(parsed, multicrate_order) do
    parsed
    |> apply_moves(multicrate_order)
    |> Enum.map(&Stack.peek/1)
    |> Enum.join("")
  end

  defp parse_stacks(setup) do
    [numbers | contents] = Enum.reverse(setup)
    count = numbers |> String.trim() |> String.last() |> String.to_integer()

    stacks = for _ <- 1..count, do: Stack.new()

    contents
    |> Enum.map(&parse_stack_assignment/1)
    |> Enum.reduce(stacks, &assign_to_stacks/2)
  end

  defp parse_stack_assignment(line) do
    line
    |> String.codepoints()
    |> Enum.chunk_every(4)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.map(fn
      "    " ->
        nil

      "[" <> rest ->
        String.first(rest)
    end)
  end

  defp assign_to_stacks(assignment, stacks) do
    assignment_padding = List.duplicate(nil, length(stacks) - length(assignment))

    Enum.zip(stacks, assignment ++ assignment_padding)
    |> Enum.map(fn
      {stack, nil} -> stack
      {stack, value} -> Stack.push(stack, value)
    end)
  end

  defp parse_moves(moves) do
    moves
    |> Enum.map(&parse_move/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_move(""), do: nil

  defp parse_move(description) do
    Regex.scan(~r/\d+/, description)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
