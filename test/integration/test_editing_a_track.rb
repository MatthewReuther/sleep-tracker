require_relative '../test_helper'

class EditingAtrackTest < Minitest::Test

  def test_user_left_tracks_unchanged
    shell_output = ""
    expected_output = main_menu
    test_track = "9 hours"
    Track.new(test_track).save
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      pipe.puts "2" # List
      expected_output << "1. #{test_track}\n"
      expected_output << "2. Exit\n"
      pipe.puts "1"
      expected_output << actions_menu
      pipe.puts "3" # Exit
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
    end
    assert_equal expected_output, shell_output
  end

  def test_happy_path_editing_a_track
    shell_output = ""
    expected_output = main_menu
    test_track = "9 hours"
    track = Track.new(test_track)
    track.save
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      pipe.puts "2" # List
      expected_output << "1. #{test_track}\n"
      expected_output << "2. Exit\n"
      pipe.puts "1"
      expected_output << actions_menu
      pipe.puts "1" # Edit
      expected_output << "Enter new hours of sleep to track:\n"
      pipe.puts "8 hours"
      expected_output << "Hours tracked have been updated to: \"8 hours\"\n"
      expected_output << main_menu
      pipe.puts "3" # Exit
      expected_output << "Good luck, see you soon!\n"
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
    end
    assert_equal expected_output, shell_output
    new_hours_slept = Track.find(track.id).hours_slept
    assert_equal "8 hours", new_hours_slept
  end

  def test_sad_path_editing_a_track
    shell_output = ""
    expected_output = main_menu
    test_track = "9 hours"
    track = Track.new(test_track)
    track.save
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      pipe.puts "2" # List
      expected_output << "1. #{test_track}\n"
      expected_output << "2. Exit\n"
      pipe.puts "1"
      expected_output << actions_menu
      pipe.puts "1" # Edit
      expected_output << "Enter new hours of sleep to track:\n"
      pipe.puts ""
      expected_output << "\"\" is not valid input to track your hours of sleep.\n"
      expected_output << "Enter new hours of sleep to track:\n"
      pipe.puts "8 hours"
      expected_output << "Hours tracked have been updated to: \"8 hours\"\n"
      expected_output << main_menu
      pipe.puts "3" # Exit
      expected_output << "Good luck, see you soon!\n"
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
    end
    assert_equal expected_output, shell_output
    new_hours_slept = Track.find(track.id).hours_slept
    assert_equal "8 hours", new_hours_slept
  end

end