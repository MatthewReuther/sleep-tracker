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
  def test_happy_path_adding_a_goal
    shell_output = ""
    expected_output = main_menu
    test_goal = "6 hours"
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      pipe.puts "1"
      expected_output << "How many hours of sleep would you like to track?\n"
      pipe.puts test_goal
      expected_output << "\"#{test_goal}\" has been added\n"
      expected_output << main_menu
      pipe.puts "2" #List Goals
      expected_output << "1. #{test_goal}\n"
      expected_output << "2. Exit\n"
      expected_output << "Exit\n"
      expected_output << exit_from(pipe)
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
    end
    assert_equal expected_output, shell_output
  end

  def test_sad_path_adding_a_goal
    shell_output = ""
    happy_goal = "7 hours"
    expected_output = main_menu
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      pipe.puts "1"
      expected_output << "How many hours of sleep would you like to track?\n"
      pipe.puts ""
      expected_output << "\"\" is not valid input to track your hours of sleep.\n"
      expected_output << "How many hours of sleep would you like to track?\n"
      pipe.puts happy_goal
      expected_output << "\"#{happy_goal}\" has been added\n"
      expected_output << main_menu
      pipe.puts "2"
      expected_output << "1. #{happy_goal}\n"
      expected_output << "2. Exit\n"
      expected_output << "Exit\n"
      expected_output << exit_from(pipe)
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
    end
    assert_equal expected_output, shell_output
  end
end
