require_relative "../test_helper"

describe GoalsController do

  describe ".index" do
    let(:controller) {GoalsController.new}

    it "should say no goals found when empty" do
      actual_output = controller.index
      expected_output = "No goals found. Add a goal.\n"
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
      goal_name = "       "
      result = controller.add(goal_name)
      assert_equal "\"\" is not a valid goal name.", result
    end

    it "should only add goals that make sense" do
      goal_name = "77777777"
      controller.add(goal_name)
      assert_equal 0, Goal.count
    end
  end
end