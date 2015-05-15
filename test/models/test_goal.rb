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

  describe ".initialize" do
    it "sets the name attribute" do
      goal = Goal.new("foo")
      assert_equal "foo", goal.name
    end
  end

  describe ".save" do
    describe "if the model is valid" do
      let(:goal){ Goal.new("roast a pig") }
      it "should return true" do
        assert goal.save
      end
      it "should save the model to the database" do
        goal.save
        assert_equal 1, Goal.count
        last_row = Database.execute("SELECT * FROM goals")[0]
        database_name = last_row['name']
        assert_equal "roast a pig", database_name
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
      it "should populate the error messages" do
        goal.save
        assert_equal "\"\" is not a valid goal name.", goal.errors
      end
    end
  end
end