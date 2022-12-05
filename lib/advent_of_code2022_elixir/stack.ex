defmodule AdventOfCode2022Elixir.Stack do
  defstruct [:stack]

  def new do
    %__MODULE__{stack: []}
  end

  def pop(stack, n \\ 1) do
    popped = Enum.take(stack.stack, n)
    left = Enum.drop(stack.stack, n)

    {popped, %__MODULE__{stack: left}}
  end

  def push(stack, elements) when is_list(elements) do
    Enum.reduce(elements, stack, fn element, stack ->
      push(stack, element)
    end)
  end

  def push(stack, element) do
    %{stack | stack: [element | stack.stack]}
  end

  def contents(stack) do
    Enum.join(stack.stack, "")
  end

  def peek(stack) do
    hd(stack.stack)
  end
end
