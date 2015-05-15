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

  end

end