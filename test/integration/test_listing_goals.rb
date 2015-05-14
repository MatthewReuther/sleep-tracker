require_relative '../test_helper'

class TestListingGoals < Minitest::Test

  def test_listing_no_goals
  shell_output = ""
  expected_output = ""
  IO.popen('./sleep_tracker manage', 'r+') do |pipe|
    expected_output << main_menu
    pipe.puts "2"
    expected_output << "No goals found. Add a goal.\n"
    pipe.close_write
    shell_output = pipe.read
  end
  assert_equal expected_output, shell_output
  end

  def test_listing_multiple_goals
    create_goal("five")
    create_goal("six")
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      expected_output << main_menu
      pipe.puts "2" # List all goals
      expected_output << "1. five\n"
      expected_output << "2. six\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end
end
