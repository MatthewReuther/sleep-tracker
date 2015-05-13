require_relative '../test_helper'

class TestBasicUsage < Minitest::Test
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