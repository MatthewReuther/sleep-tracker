class Goal
  attr_reader :id, :errors
  attr_accessor :name

  def initialize(name = nil)
    self.name = name
  end

  def ==(other)
    other.is_a?(Goal) && other.id == self.id
  end

  def self.all
    Database.execute("select * from goals order by name ASC").map do |row|
      populate_from_database(row)
    end
  end

  def self.count
    Database.execute("select count(id) from goals")[0][0]
  end

  def self.find(id)
    row = Database.execute("select * from goals where id = ?", id).first
    if row.nil?
      nil
    else
      populate_from_database(row)
    end
  end

  def self.find_by_name(name)
    row = Database.execute("select * from goals where name LIKE ?", name).first
    if row.nil?
      nil
    else
      populate_from_database(row)
    end
  end

  def valid?
    if name.nil? or name.empty? or /^\d+$/.match(name)
      @errors = "\"#{name}\" is not a valid goal name."
      false
    else
      @errors = nil
      true
    end
  end

  def save
    return false unless valid?
    if @id.nil?
      Database.execute("INSERT INTO goals (name) VALUES (?)", name)
      @id = Database.execute("SELECT last_insert_rowid()")[0]['last_insert_rowid()']
    else
      Database.execute("UPDATE goals SET name=? WHERE id=?", name, id)
      true
    end
  end

  private

  def self.populate_from_database(row)
    goal = Goal.new
    goal.name = row['name']
    goal.instance_variable_set(:@id, row['id'])
    goal
  end
end