defmodule Mix.Tasks.Day do
  use Mix.Task

  @package "advent_of_code2022_elixir"

  @shortdoc "Scaffold up a new puzzle / day"
  def run([day_number, name]) do
    day = String.pad_leading(day_number, 2, "0")

    lib_path = "lib/#{@package}/day_#{day}_#{name}.ex"
    test_path = "test/#{@package}/day_#{day}_#{name}_test.exs"
    data_path = "lib/data/#{day}"

    module_name = "Day#{day}#{camelize(name)}"

    create_file(lib_path, """
    defmodule #{camelize @package}.#{module_name} do
      @moduledoc \"\"\"

      \"\"\"
    end
    """)

    create_file(test_path, """
    defmodule #{camelize @package}.#{module_name}Test do
      use ExUnit.Case, async: true

      import #{camelize @package}.#{module_name}

      test "the truth" do
        assert true
      end
    end
    """)

    create_file(data_path, "")
  end

  defp create_file(path, contents) do
    unless File.dir?(Path.dirname(path)) do
      File.mkdir_p(Path.dirname(path))
    end

    if File.exists?(path) do
      IO.puts("File #{path} already exists!")
    else
      {:ok, io} = File.open(path, [:write])

      IO.binwrite(io, contents)

      :ok = File.close(io)
    end
  end

  defp camelize(str) do
    str
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("")
  end
end
