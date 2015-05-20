require_relative '../test_helper'

describe Track do
  describe "#all" do
    describe "if there are no tracks in the database" do
      it "should return an empty array" do
        assert_equal [], Track.all
      end
    end
    describe "if there are tracks" do
      before do
        create_track("Six")
        create_track("Five")
        create_track("Ten")
      end
      it "should return an array" do
        # You don't need to be pedantic like this.
        # This is just an example to remind you that you can use multiple "its"
        assert_equal Array, Track.all.class
      end
      it "populates the returned tracks' ids" do
        expected_ids = Database.execute("SELECT id FROM tracks order by id DESC").map{ |row| row['id'] }
        actual_ids = Track.all.map{ |track| track.id }
        assert_equal expected_ids, actual_ids
      end
    end
  end

  describe "#find" do
    let(:track){ Track.new("6 hours") }
    before do
      track.save
    end
    describe "if there isn't a matching track in the database" do
      it "should return nil" do
        assert_equal nil, Track.find(14)
      end
    end
    describe "if there is a matching track in the database" do
      it "should return the track, populated with id and hours_slept" do
        actual = Track.find(track.id)
        assert_equal track.id, actual.id
        assert_equal track.hours_slept, actual.hours_slept
      end
    end
  end

  describe "equality" do
    describe "when the track ids are the same" do
      it "is true" do
        track1 = Track.new("foo")
        track1.save
        track2 = Track.all.first
        assert_equal track1, track2
      end
    end
    describe "when the track ids are not the same" do
      it "is true" do
        track1 = Track.new("foo")
        track1.save
        track2 = Track.new("foo")
        track2.save
        assert track1 != track2
      end
    end
  end

  describe "#count" do
    describe "if there are no tracks in the database" do
      it "should return 0" do
        assert_equal 0, Track.count
      end
    end
    describe "if there are tracks" do
      before do
        create_track("Six")
        create_track("Five")
        create_track("Ten")
      end
      it "should return the correct count" do
        assert_equal 3, Track.count
      end
    end
  end

  describe ".initialize" do
    it "sets the hours_slept attribute" do
      track = Track.new("foo")
      assert_equal "foo", track.hours_slept
    end
  end

  describe ".save" do
    describe "if the model is valid" do
      let(:track){ Track.new("9 hours") }
      it "should return true" do
        assert track.save
      end
      it "should save the model to the database" do
        track.save
        assert_equal 1, Track.count
        last_row = Database.execute("SELECT * FROM tracks")[0]
        database_hours_slept = last_row['hours_slept']
        assert_equal "9 hours", database_hours_slept
      end
      it "should populate the model with id from the database" do
        track.save
        last_row = Database.execute("SELECT * FROM tracks")[0]
        database_id = last_row['id']
        assert_equal database_id, track.id
      end
    end

    describe "if the model is invalid" do
      let(:track){ Track.new("") }
      it "should return false" do
        refute track.save
      end
      it "should not save the model to the database" do
        track.save
        assert_equal 0, Track.count
      end
      it "should populate the error messages" do # I have some qualms.
        track.save
        assert_equal "\"\" is not valid input to track your hours of sleep.", track.errors
      end
    end
  end

  describe ".valid?" do
    describe "with valid data" do
      let(:track){ Track.new("10 hours") }
      it "returns true" do
        assert track.valid?
      end
      it "should set errors to nil" do
        track.valid?
        assert track.errors.nil?
      end
    end
    describe "with no hours_slept" do
      let(:track){ Track.new(nil) }
      it "returns false" do
        refute track.valid?
      end
      it "sets the error message" do
        track.valid?
        assert_equal "\"\" is not valid input to track your hours of sleep.", track.errors
      end
    end
    describe "with empty hours_slept" do
      let(:track){ Track.new("") }
      it "returns false" do
        refute track.valid?
      end
      it "sets the error message" do
        track.valid?
        assert_equal "\"\" is not valid input to track your hours of sleep.", track.errors
      end
    end
    describe "with a hours_slept with no letter characters" do
      let(:track){ Track.new("777") }
      it "returns false" do
        refute track.valid?
      end
      it "sets the error message" do
        track.valid?
        assert_equal "\"777\" is not valid input to track your hours of sleep.", track.errors
      end
    end
    describe "with a previously invalid hours_slept" do
      let(:track){ Track.new("666") }
      before do
        refute track.valid?
        track.hours_slept = "11 hours"
        assert_equal "11 hours", track.hours_slept
      end
      it "should return true" do
        assert track.valid?
      end
      it "should not have an error message" do
        track.valid?
        assert_nil track.errors
      end
    end
  end
  describe "updating data" do
    describe "edit previously entered track" do
      let(:track_hours_slept){ "11 hours" }
      let(:new_track_hours_slept){ "9 hours" }
      it "should update track hours_slept but not id" do
        track = Track.new(track_hours_slept)
        track.save
        assert_equal 1, Track.count
        track.hours_slept = new_track_hours_slept
        assert track.save
        assert_equal 1, Track.count
        last_row = Database.execute("SELECT * FROM tracks")[0]
        assert_equal new_track_hours_slept, last_row['hours_slept']
      end
      it "shouldn't update other tracks' hours_slepts" do
        hours = Track.new("6 hours")
        hours.save
        track = Track.new(track_hours_slept)
        track.save
        assert_equal 2, Track.count
        track.hours_slept = new_track_hours_slept
        assert track.save
        assert_equal 2, Track.count

        hours2 = Track.find(hours.id)
        assert_equal hours.hours_slept, hours2.hours_slept
      end
    end
    describe "failed edit of previously entered track" do
      let(:track_hours_slept){ "11 hours" }
      let(:new_track_hours_slept){ "" }
      it "does not update anything" do
        track = Track.new(track_hours_slept)
        track.save
        assert_equal 1, Track.count
        track.hours_slept = new_track_hours_slept
        refute track.save
        assert_equal 1, Track.count
        last_row = Database.execute("SELECT * FROM tracks")[0]
        assert_equal track_hours_slept, last_row['hours_slept']
      end
    end
  end
  describe "#find_by_hours_slept" do
    describe "find when there's nothing in database" do

      before(:all) do
        track = Track.new("11 hours")
        track.save
      end

      it "should exist" do
        assert_respond_to Track, :find_by_hours_slept
      end
      it "should return empty array" do
        results = Track.find_by_hours_slept("7 hours")
        assert_equal nil, results
      end
      it "should find only one item by a given hours_slept" do
        results = Track.find_by_hours_slept("11 hours")
        assert_equal "11 hours", results.hours_slept
      end
    end
  end
end