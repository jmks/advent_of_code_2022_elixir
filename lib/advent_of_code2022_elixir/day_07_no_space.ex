defmodule AdventOfCode2022Elixir.Day07NoSpace do
  @moduledoc """
  --- Day 7: No Space Left On Device ---

  You can hear birds chirping and raindrops hitting leaves as the expedition proceeds. Occasionally, you can even hear much louder sounds in the distance; how big do the animals get out here, anyway?

  The device the Elves gave you has problems with more than just its communication system. You try to run a system update:

  $ system-update --please --pretty-please-with-sugar-on-top
  Error: No space left on device

  Perhaps you can delete some files to make space for the update?

  You browse around the filesystem to assess the situation and save the resulting terminal output (your puzzle input). For example:

  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k

  The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files). The outermost directory is called /. You can navigate around te filesystem, moving into or out of directories and listing the contents of the directory you're currently in.

  Within the terminal output, lines that begin with $ are commands you executed, very much like some modern computers:

    cd means change directory. This changes which directory is the current directory, but the specific result depends on the argument:
        cd x moves in one level: it looks in the current directory for the directory named x and makes it the current directory.
        cd .. moves out one level: it finds the directory that contains the current directory, then makes that directory the current directory.
        cd / switches the current directory to the outermost directory, /.
    ls means list. It prints out all of the files and directories immediately contained by the current directory:
        123 abc means that the current directory contains a file named abc with size 123.
        dir xyz means that the current directory contains a directory named xyz.

  Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

  - / (dir)
  - a (dir)
    - e (dir)
      - i (file, size=584)
    - f (file, size=29116)
    - g (file, size=2557)
    - h.lst (file, size=62596)
  - b.txt (file, size=14848514)
  - c.dat (file, size=8504156)
  - d (dir)
    - j (file, size=4060174)
    - d.log (file, size=8033020)
    - d.ext (file, size=5626152)
    - k (file, size=7214296)

  Here, there are four directories: / (the outermost directory), a and d (which are in /), and e (which is in a). These directories also contain files of various sizes.

  Since the disk is full, your first step should probably be to find directories that are good candidates for deletion. To do this, you need to determine the total size of each directory. The total size of a directory is the sum of the sizes of the files it contains, directly or indirectly. (Directories themselves do not count as having any intrinsic size.)

  The total sizes of the directories above can be found as follows:

  The total size of directory e is 584 because it contains a single file i of size 584 and no other directories.
  The directory a has total size 94853 because it contains files f (size 29116), g (size 2557), and h.lst (size 62596), plus file i indirectly (a contains e which contains i).
  Directory d has total size 24933642.
  As the outermost directory, / contains every file. Its total size is 48381165, the sum of the size of every file.

  To begin, find all of the directories with a total size of at most 100000, then calculate the sum of their total sizes. In the example above, these directories are a and e; the sum of their total sizes is 95437 (94853 + 584). (As in this example, this process can count files more than once!)

  Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?

  --- Part Two ---

  Now, you're ready to choose a directory to delete.

  The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000. You need to find a directory you can delete that will free up enough space to run the update.

  In the example above, the total size of the outermost directory (and thus the total amount of used space) is 48381165; this means that the size of the unused space must currently be 21618835, which isn't quite the 30000000 required by the update. Therefore, the update still requires a directory with total size of at least 8381165 to be deleted before it can run.

  To achieve this, you have the following options:

    Delete directory e, which would increase unused space by 584.
    Delete directory a, which would increase unused space by 94853.
    Delete directory d, which would increase unused space by 24933642.
    Delete directory /, which would increase unused space by 48381165.

  Directories e and a are both too small; eleting them would not free up enough space. However, directories d and / are both big enough! Between these, choose the smallest: d, increasing unused space by 24933642.

  Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?
  """

  alias AdventOfCode2022Elixir.Stack

  def sum_dirs_under(input, max_size \\ 100_000) do
    input
    |> directory_sizes()
    |> Enum.filter(fn {_, size} -> size <= max_size end)
    |> Enum.map(fn {_, size} -> size end)
    |> Enum.sum()
  end

  def deleted_directory_size(input) do
    total_size = 70_000_000
    required_size = 30_000_000

    dirs = directory_sizes(input)

    {"/", current_size} = List.last(dirs)
    free_size = total_size - current_size
    delete_size = required_size - free_size

    dirs
    |> Enum.filter(fn {_dir, size} -> size >= delete_size end)
    |> List.first()
    |> elem(1)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def interpret(instructions) do
    path = Stack.new()

    do_interpret(instructions, path, [])
  end

  def directory_sizes(input) when is_binary(input) do
    input
    |> parse()
    |> interpret()
    |> directory_sizes()
  end

  def directory_sizes(files) do
    dirs = %{}

    do_directory_sizes(files, dirs)
  end

  defp parse_line("$ ls"), do: {:cmd, :ls}
  defp parse_line("$ cd " <> dir), do: {:cmd, :cd, dir}
  defp parse_line("dir " <> dir), do: {:dir, dir}

  defp parse_line(file_entry) do
    [size, name] = String.split(file_entry, " ", parts: 2)

    {:file, name, String.to_integer(size)}
  end

  defp do_interpret([], _, files), do: Enum.reverse(files)

  defp do_interpret([{:cmd, :cd, "/"} | rest], _path, files) do
    new_path = Stack.new()

    do_interpret(rest, new_path, files)
  end

  defp do_interpret([{:cmd, :cd, ".."} | rest], path, files) do
    {_, new_path} = Stack.pop(path)

    do_interpret(rest, new_path, files)
  end

  defp do_interpret([{:cmd, :cd, dir} | rest], path, files) do
    new_path = Stack.push(path, dir)

    do_interpret(rest, new_path, files)
  end

  defp do_interpret([{:cmd, :ls} | rest], path, files) do
    do_interpret(rest, path, files)
  end

  defp do_interpret([{:dir, _name} | rest], path, files) do
    do_interpret(rest, path, files)
  end

  defp do_interpret([{:file, name, size} | rest], path, files) do
    new_path = Stack.push(path, name)
    new_file = {file_path(new_path), size}

    do_interpret(rest, path, [new_file | files])
  end

  defp do_directory_sizes([], dirs) do
    Enum.sort_by(dirs, fn {_dir, size} -> size end)
  end

  defp do_directory_sizes([{path, size} | rest], dirs) do
    new_dirs =
      path
      |> all_dirs()
      |> Enum.reduce(dirs, fn dir, dirs ->
        Map.update(dirs, dir, size, &(&1 + size))
      end)

    do_directory_sizes(rest, new_dirs)
  end

  def all_dirs(path) do
    parts = path |> Path.dirname() |> String.split("/", trim: true)

    dirs =
      if length(parts) == 0 do
        []
      else
        for i <- 1..length(parts) do
          suffix = parts |> Enum.take(i) |> Enum.join("/")

          "/" <> suffix
        end
      end

    ["/" | dirs]
  end

  defp file_path(%Stack{} = path) do
    suffix =
      path
      |> Stack.to_list()
      |> Enum.reverse()
      |> Enum.join("/")

    "/" <> suffix
  end
end
