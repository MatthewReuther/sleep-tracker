class EditingAGoalTest < Minitest::Test

  def test_user_left_goal_unchanged
    skip
    shell_output = ""
    expected_output = main_menu
    test_goal = "8 hours"
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      pipe.puts "2"
      expected_output << "What goal would you like to add?\n"
      pipe.puts test_goal
      expected_output << "\"#{test_goal}\" has been added\n"
      expected_output << main_menu
      pipe.puts "2"
      expected_output << "1. #{test_goal}\n"
      pipe.puts "1"
      expected_output << actions_menu
      pipe.puts "3"
      expected_out << main_menu
      shell_output = pipe.read
      pipe.close_write
      pipe.close_read
    end
    assert_equal expected_output, shell_output
  end

  def test_happy_path_editing_a_goal
    skip
  end

  def test_sad_path_editing_a_goal
    skip
  end

end