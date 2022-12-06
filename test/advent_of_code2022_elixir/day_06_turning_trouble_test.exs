defmodule AdventOfCode2022Elixir.Day06TurningTroubleTest do
  use ExUnit.Case, async: true

  import AdventOfCode2022Elixir.Day06TurningTrouble

  test "chars_before_start_of_packet" do
    assert chars_before_start_of_packet("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
    assert chars_before_start_of_packet("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert chars_before_start_of_packet("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert chars_before_start_of_packet("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    assert chars_before_start_of_packet("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
    assert chars_before_start_of_packet(Input.raw(6)) == 1142
  end

  test "chars_before_start_of_message" do
    assert chars_before_start_of_message("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
    assert chars_before_start_of_message("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    assert chars_before_start_of_message("nppdvjthqldpwncqszvftbrmjlhg") == 23
    assert chars_before_start_of_message("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
    assert chars_before_start_of_message("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
    assert chars_before_start_of_message(Input.raw(6)) == 2803
  end
end
