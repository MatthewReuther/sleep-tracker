require_relative "../test_helper"

describe TracksController do

  describe ".index" do
    let(:controller) {TracksController.new}

    it "should say no tracks found when empty" do
      skip
      # Temporarily skipped out.  To fix, see: https://github.com/JEG2/highline/issues/28
      actual_output = controller.index
      expected_output = "No tracked hours of sleep found. Add hours of sleep to track.\n"
      assert_equal expected_output, actual_output
    end
  end

  describe ".add" do
    let(:controller) {TracksController.new}

    it "should add a track" do
      controller.add("7 hours")
      assert_equal 1, Track.count
    end

    it "should not add track all spaces" do
      track_hours_slept = "       "
      result = controller.add(track_hours_slept)
      assert_equal "\"\" is not valid input to track your hours of sleep.", result
    end

    it "should only add tracks that make sense" do
      track_hours_slept = "77777777"
      controller.add(track_hours_slept)
      assert_equal 0, Track.count
    end

  end

end