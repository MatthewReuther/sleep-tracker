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

describe ".valid?" do
    describe "with valid data" do
      let(:goal){ Goal.new("eat corn on the cob") }
      it "returns true" do
        assert goal.valid?
      end
      it "should set errors to nil" do
        goal.valid?
        assert goal.errors.nil?
      end
    end
    describe "with no name" do
      let(:goal){ Goal.new(nil) }
      it "returns false" do
        refute goal.valid?
      end
      it "sets the error message" do
        goal.valid?
        assert_equal "\"\" is not a valid goal name.", goal.errors
      end
    end
    describe "with empty name" do
      let(:goal){ Goal.new("") }
      it "returns false" do
        refute goal.valid?
      end
      it "sets the error message" do
        goal.valid?
        assert_equal "\"\" is not a valid goal name.", goal.errors
      end
    end
    describe "with a name with no letter characters" do
      let(:goal){ Goal.new("777") }
      it "returns false" do
        refute goal.valid?
      end
      it "sets the error message" do
        goal.valid?
        assert_equal "\"777\" is not a valid goal name.", goal.errors
      end
    end
    describe "with a previously invalid name" do
      let(:goal){ Goal.new("666") }
      before do
        refute goal.valid?
        goal.name = "Eat a pop tart"
        assert_equal "Eat a pop tart", goal.name
      end
      it "should return true" do
        assert goal.valid?
      end
      it "should not have an error message" do
        goal.valid?
        assert_nil goal.errors
      end
    end
    describe ".update" do
      describe "edit previously entered goal" do
        let(:goal_name){ "Eat a pop tart" }
        let(:new_goal_name){ "Eat a toaster strudel" }
        it "should update goal name but not id" do
          goal = Goal.new(goal_name)
          goal.save
          assert_equal 1, Goal.count
          goal.update(goal_name, new_goal_name)
          last_row = Database.execute("SELECT * FROM goals WHERE name LIKE ?", goal_name)[0]
          assert_equal 1, Goal.count
          assert_equal new_goal_name, last_row['name']
        end
      end
    end
  end
end
