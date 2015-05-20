require_relative "../test_helper"

describe GoalsController do

  describe ".index" do
    let(:controller) {GoalsController.new}

    it "should say no goals found when empty" do
      skip
      # Temporarily skipped out.  To fix, see: https://github.com/JEG2/highline/issues/28
      actual_output = controller.index
      expected_output = "No tracked hours of sleep found. Add hours of sleep to track.\n"
      assert_equal expected_output, actual_output
    end
  end

  describe ".add" do
    let(:controller) {GoalsController.new}

    it "should add a goal" do
      controller.add("7 hours")
      assert_equal 1, Goal.count
    end

    it "should not add goal all spaces" do
      goal_hours_slept = "       "
      result = controller.add(goal_hours_slept)
      assert_equal "\"\" is not valid input to track your hours of sleep.", result
    end

    it "should only add goals that make sense" do
      goal_hours_slept = "77777777"
      controller.add(goal_hours_slept)
      assert_equal 0, Goal.count
    end

  end

end