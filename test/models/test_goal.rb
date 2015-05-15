require_relative '../test_helper'

describe Goal do
  describe "#all" do
    describe "if there are no goals in the database" do
      it "should return an empty array" do
        assert_equal [], Goal.all
      end
    end
    describe "if there are goals" do
      before do
        create_goal("six")
        create_goal("five")
        create_goal("ten")
      end
      it "should return an array" do
        # You don't need to be pedantic like this.
        # This is just an example to remind you that you can use multiple "its"
        assert_equal Array, Goal.all.class
      end
      it "should return the goals in alphabetical order" do
        expected = ["five", "six", "ten"]
        actual = Goal.all.map{ |goal| goal.name }
        assert_equal expected, actual
      end
    end
  end

  describe "#count" do
    describe "if there are no goals in the database" do
      it "should return 0" do
        assert_equal 0, Goal.count
      end
    end
    describe "if there are goals" do
      before do
        create_goal("six")
        create_goal("five")
        create_goal("ten")
      end
      it "should return the correct count" do
        assert_equal 3, Goal.count
      end
    end
  end

  describe "#create" do
    describe "if we need to add goals" do
      it "should add a goal" do
        Goal.create("tweleve hours")
        assert_equal 1, Goal.count
      end

      it "should reject empty strings" do
       assert_raises(ArgumentError) { Goal.create("")}
      end
    end
  end
end