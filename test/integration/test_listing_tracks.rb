require_relative '../test_helper'

class TestListingTracks < Minitest::Test

  def test_listing_no_tracks
  shell_output = ""
  expected_output = ""
  IO.popen('./sleep_tracker manage', 'r+') do |pipe|
    expected_output << main_menu
    pipe.puts "2"
    expected_output << "No tracked hours of sleep found. Add hours of sleep to track.\n"
      expected_output << main_menu
      pipe.puts "Exit"
      expected_output << "Good luck, see you soon!\n"
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
  end
  assert_equal expected_output, shell_output
  end

  def test_listing_multiple_tracks
    create_track("6 hours")
    create_track("5 hours")
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      expected_output << main_menu
      pipe.puts "2" # List all tracks
      expected_output << "1. 5 hours\n"
      expected_output << "2. 6 hours\n"
      expected_output << "3. Exit\n"
      expected_output << "Exit\n"
      expected_output << exit_from(pipe)
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end
end
