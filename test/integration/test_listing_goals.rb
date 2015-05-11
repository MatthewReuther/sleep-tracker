require_relative '../test_helper'

class TestListingGoals < Minitest::Test

  def test_listing_no_goals
  shell_output = ""
  expected_output = ""
  IO.popen('./sleep_tracker manage', 'r+') do |pipe|
    expected_output = <<EOS
1. Add a goal
2. List all goals
3. Exit
EOS
    pipe.puts "2"
    expected_output << "No goals found. Add a goal.\n"
    pipe.close_write
    shell_output = pipe.read
  end
  assert_equal expected_output, shell_output
  end
end