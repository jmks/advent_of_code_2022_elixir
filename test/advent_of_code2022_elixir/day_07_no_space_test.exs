defmodule AdventOfCode2022Elixir.Day07NoSpaceTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day07NoSpace

  @example """
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
  """

  test "parse/1" do
    assert parse("""
           $ cd /
           $ ls
           dir a
           14848514 b.txt
           8504156 c.dat
           dir d
           $ cd ..
           """) == [
             {:cmd, :cd, "/"},
             {:cmd, :ls},
             {:dir, "a"},
             {:file, "b.txt", 14_848_514},
             {:file, "c.dat", 8_504_156},
             {:dir, "d"},
             {:cmd, :cd, ".."}
           ]
  end

  test "interpret/1" do
    assert interpret([
             {:dir, "/"},
             {:cmd, :cd, "/"},
             {:cmd, :ls},
             {:dir, "a"},
             {:file, "b.txt", 14_848_514},
             {:file, "c.dat", 8_504_156},
             {:dir, "d"},
             {:cmd, :cd, ".."}
           ]) == [
             {"/b.txt", 14_848_514},
             {"/c.dat", 8_504_156}
           ]
  end

  test "directory_sizes/1" do
    assert directory_sizes([
             {"/1.text", 1},
             {"/2.text", 2},
             {"/a/5.text", 5},
             {"/a/b/7.text", 7},
             {"/c/11.text", 11}
           ]) == [
             {"/a/b", 7},
             {"/c", 11},
             {"/a", 12},
             {"/", 26}
           ]

    assert directory_sizes(@example |> parse() |> interpret()) == [
             {"/a/e", 584},
             {"/a", 94853},
             {"/d", 24_933_642},
             {"/", 48_381_165}
           ]
  end

  test "all_dirs/1" do
    assert all_dirs("/") == ["/"]
  end

  test "sum_dirs_under/1" do
    assert sum_dirs_under(@example) == 95437
    assert sum_dirs_under(Input.raw(7)) == 1
  end
end
