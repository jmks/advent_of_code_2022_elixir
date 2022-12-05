defmodule AdventOfCode2022Elixir.StackTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2022Elixir.Stack

  describe "Stack" do
    test "new stack is empty" do
      assert Stack.contents(Stack.new()) == ""
    end

    test "push to stack" do
      s = Stack.new()

      s = Stack.push(s, "a")
      s = Stack.push(s, "b")
      s = Stack.push(s, "c")

      assert Stack.contents(s) == "cba"
    end

    test "push many in stack order" do
      s = Stack.new()

      s = Stack.push_many(s, ["c", "b", "a"], :stack)

      assert Stack.contents(s) == "abc"
    end

    test "push many preserving order" do
      s = Stack.new()

      s = Stack.push_many(s, ["c", "b", "a"], :preserve)

      assert Stack.contents(s) == "cba"
    end

    test "pop" do
      s = Stack.new()
      s = Stack.push(s, "a")

      {popped, s} = Stack.pop(s)

      assert popped == ["a"]
      assert Stack.contents(s) == ""
    end

    test "pop many" do
      s = Stack.new()
      s = Stack.push(s, ["a", "b", "c"])

      {popped, s} = Stack.pop(s, 2)

      assert popped == ["c", "b"]
      assert Stack.contents(s) == "a"
    end
  end
end
