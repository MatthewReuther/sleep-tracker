class Track
  attr_reader :id, :errors
  attr_accessor :hours_slept

  def initialize(hours_slept = nil)
    self.hours_slept = hours_slept
  end

  def ==(other)
    other.is_a?(Track) && other.id == self.id
  end

  def self.all
    Database.execute("select * from tracks order by hours_slept ASC").map do |row|
      populate_from_database(row)
    end
  end

  def self.count
    Database.execute("select count(id) from tracks")[0][0]
  end

  def self.find(id)
    row = Database.execute("select * from tracks where id = ?", id).first
    if row.nil?
      nil
    else
      populate_from_database(row)
    end
  end

  def self.find_by_hours_slept(hours_slept)
    row = Database.execute("select * from tracks where hours_slept LIKE ?", hours_slept).first
    if row.nil?
      nil
    else
      populate_from_database(row)
    end
  end

  def valid?
    if hours_slept.nil? or hours_slept.empty? or /^\d+$/.match(hours_slept)
      @errors = "\"#{hours_slept}\" is not valid input to track your hours of sleep."
      false
    else
      @errors = nil
      true
    end
  end

  def save
    return false unless valid?
    if @id.nil?
      Database.execute("INSERT INTO tracks (hours_slept) VALUES (?)", hours_slept)
      @id = Database.execute("SELECT last_insert_rowid()")[0]['last_insert_rowid()']
    else
      Database.execute("UPDATE tracks SET hours_slept=? WHERE id=?", hours_slept, id)
      true
    end
  end

  def self.delete(id)
    Database.execute("delete from tracks where id = ?", id)
  end

  private

  def self.populate_from_database(row)
    track = Track.new
    track.hours_slept = row['hours_slept']
    track.instance_variable_set(:@id, row['id'])
    track
  end
end