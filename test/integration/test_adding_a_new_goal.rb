require_relative '../test_helper'

# Adding new goals

# In hopes to be able to sleep better I want to be able to add sleeping goals.

# Usage Example:
# ./sleep_goal_tracker manage
#   Add a goal
#   List all gaols
#   Exit 1 What goals would you like to add? getting to be earlier "getting to be earlier" has been added
#   Add a goal
#   List all gaols
#   Exit
# Acceptance Criteria:

# Program will print out confirmation that the new goal was added
# The goals is added to the database
# After being added, the goal will be visible via. "List all goals", once that feature has been implemented
# After the addition, the user is taken back to the main manage menu

class AddingANewGoalTest < Minitest::Test

  def test_minimum_arguments_required
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker') do |pipe|
      expected_output = "[Help] Run as: ./sleep_tracker manage"
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end

  def test_manage_argument_not_given
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker asfasfa') do |pipe|
      expected_output = "[Help] Run as: ./sleep_tracker manage"
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end

  def test_manage_argument_given_then_exit
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      expected_output = <<EOS
1. Add a goal
2. List all goals
3. Exit
EOS
      pipe.puts "3"
      expected_output << "Good luck, see you soon!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end

end