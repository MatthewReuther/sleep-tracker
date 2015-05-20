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
        create_goal("Six")
        create_goal("Five")
        create_goal("Ten")
      end
      it "should return an array" do
        # You don't need to be pedantic like this.
        # This is just an example to remind you that you can use multiple "its"
        assert_equal Array, Goal.all.class
      end
      it "should return the goals in alphabetical order" do
        expected = ["Five", "Six", "Ten"]
        actual = Goal.all.map{ |goal| goal.hours_slept }
        assert_equal expected, actual
      end
      it "populates the returned goals' ids" do
        expected_ids = Database.execute("SELECT id FROM goals order by hours_slept ASC").map{ |row| row['id'] }
        actual_ids = Goal.all.map{ |goal| goal.id }
        assert_equal expected_ids, actual_ids
      end
    end
  end

  describe "#find" do
    let(:goal){ Goal.new("6 hours") }
    before do
      goal.save
    end
    describe "if there isn't a matching goal in the database" do
      it "should return nil" do
        assert_equal nil, Goal.find(14)
      end
    end
    describe "if there is a matching goal in the database" do
      it "should return the goal, populated with id and hours_slept" do
        actual = Goal.find(goal.id)
        assert_equal goal.id, actual.id
        assert_equal goal.hours_slept, actual.hours_slept
      end
    end
  end

  describe "equality" do
    describe "when the goal ids are the same" do
      it "is true" do
        goal1 = Goal.new("foo")
        goal1.save
        goal2 = Goal.all.first
        assert_equal goal1, goal2
      end
    end
    describe "when the goal ids are not the same" do
      it "is true" do
        goal1 = Goal.new("foo")
        goal1.save
        goal2 = Goal.new("foo")
        goal2.save
        assert goal1 != goal2
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
        create_goal("Six")
        create_goal("Five")
        create_goal("Ten")
      end
      it "should return the correct count" do
        assert_equal 3, Goal.count
      end
    end
  end

  describe ".initialize" do
    it "sets the hours_slept attribute" do
      goal = Goal.new("foo")
      assert_equal "foo", goal.hours_slept
    end
  end

  describe ".save" do
    describe "if the model is valid" do
      let(:goal){ Goal.new("9 hours") }
      it "should return true" do
        assert goal.save
      end
      it "should save the model to the database" do
        goal.save
        assert_equal 1, Goal.count
        last_row = Database.execute("SELECT * FROM goals")[0]
        database_hours_slept = last_row['hours_slept']
        assert_equal "9 hours", database_hours_slept
      end
      it "should populate the model with id from the database" do
        goal.save
        last_row = Database.execute("SELECT * FROM goals")[0]
        database_id = last_row['id']
        assert_equal database_id, goal.id
      end
    end

    describe "if the model is invalid" do
      let(:goal){ Goal.new("") }
      it "should return false" do
        refute goal.save
      end
      it "should not save the model to the database" do
        goal.save
        assert_equal 0, Goal.count
      end
      it "should populate the error messages" do # I have some qualms.
        goal.save
        assert_equal "\"\" is not valid input to track your hours of sleep.", goal.errors
      end
    end
  end

  describe ".valid?" do
    describe "with valid data" do
      let(:goal){ Goal.new("10 hours") }
      it "returns true" do
        assert goal.valid?
      end
      it "should set errors to nil" do
        goal.valid?
        assert goal.errors.nil?
      end
    end
    describe "with no hours_slept" do
      let(:goal){ Goal.new(nil) }
      it "returns false" do
        refute goal.valid?
      end
      it "sets the error message" do
        goal.valid?
        assert_equal "\"\" is not valid input to track your hours of sleep.", goal.errors
      end
    end
    describe "with empty hours_slept" do
      let(:goal){ Goal.new("") }
      it "returns false" do
        refute goal.valid?
      end
      it "sets the error message" do
        goal.valid?
        assert_equal "\"\" is not valid input to track your hours of sleep.", goal.errors
      end
    end
    describe "with a hours_slept with no letter characters" do
      let(:goal){ Goal.new("777") }
      it "returns false" do
        refute goal.valid?
      end
      it "sets the error message" do
        goal.valid?
        assert_equal "\"777\" is not valid input to track your hours of sleep.", goal.errors
      end
    end
    describe "with a previously invalid hours_slept" do
      let(:goal){ Goal.new("666") }
      before do
        refute goal.valid?
        goal.hours_slept = "11 hours"
        assert_equal "11 hours", goal.hours_slept
      end
      it "should return true" do
        assert goal.valid?
      end
      it "should not have an error message" do
        goal.valid?
        assert_nil goal.errors
      end
    end
  end
  describe "updating data" do
    describe "edit previously entered goal" do
      let(:goal_hours_slept){ "11 hours" }
      let(:new_goal_hours_slept){ "9 hours" }
      it "should update goal hours_slept but not id" do
        goal = Goal.new(goal_hours_slept)
        goal.save
        assert_equal 1, Goal.count
        goal.hours_slept = new_goal_hours_slept
        assert goal.save
        assert_equal 1, Goal.count
        last_row = Database.execute("SELECT * FROM goals")[0]
        assert_equal new_goal_hours_slept, last_row['hours_slept']
      end
      it "shouldn't update other goals' hours_slepts" do
        hours = Goal.new("6 hours")
        hours.save
        goal = Goal.new(goal_hours_slept)
        goal.save
        assert_equal 2, Goal.count
        goal.hours_slept = new_goal_hours_slept
        assert goal.save
        assert_equal 2, Goal.count

        hours2 = Goal.find(hours.id)
        assert_equal hours.hours_slept, hours2.hours_slept
      end
    end
    describe "failed edit of previously entered goal" do
      let(:goal_hours_slept){ "11 hours" }
      let(:new_goal_hours_slept){ "" }
      it "does not update anything" do
        goal = Goal.new(goal_hours_slept)
        goal.save
        assert_equal 1, Goal.count
        goal.hours_slept = new_goal_hours_slept
        refute goal.save
        assert_equal 1, Goal.count
        last_row = Database.execute("SELECT * FROM goals")[0]
        assert_equal goal_hours_slept, last_row['hours_slept']
      end
    end
  end
  describe "#find_by_hours_slept" do
    describe "find when there's nothing in database" do

      before(:all) do
        goal = Goal.new("11 hours")
        goal.save
      end

      it "should exist" do
        assert_respond_to Goal, :find_by_hours_slept
      end
      it "should return empty array" do
        results = Goal.find_by_hours_slept("7 hours")
        assert_equal nil, results
      end
      it "should find only one item by a given hours_slept" do
        results = Goal.find_by_hours_slept("11 hours")
        assert_equal "11 hours", results.hours_slept
      end
    end
  end
end