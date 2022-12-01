defmodule Input do
  def raw(day) do
    filename = day |> Integer.to_string |> String.pad_leading(2, "0")

    File.read!("lib/data/#{filename}")
  end

  def ints(day) do
    day |> raw |> lines |> to_ints
  end

  def strings(day) do
    day |> raw |> lines
  end

  defp lines(input) do
    String.split(input, "\n")
  end

  defp to_ints(inputs) do
    Enum.map(inputs, &String.to_integer/1)
  end
end
