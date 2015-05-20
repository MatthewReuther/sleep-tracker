require_relative '../test_helper'

class TestBasicUsage < Minitest::Test
  def test_manage_wrong_argument_given
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker blah') do |pipe|
      expected_output = "[Help] Run as: ./sleep_tracker manage\n"
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end

  def test_manage_multiple_arguments_given
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker manage blah') do |pipe|
      expected_output = "[Help] Run as: ./sleep_tracker manage\n"
      shell_output = pipe.read
    end
    assert_equal expected_output, shell_output
  end

  def test_manage_argument_given_then_exit
    shell_output = ""
    expected_output = ""
    IO.popen('./sleep_tracker manage', 'r+') do |pipe|
      expected_output = <<EOS
1. Add hours of sleep to track
2. List all hours tracked
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