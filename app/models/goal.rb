class Goal
  attr_reader :id, :errors
  attr_accessor :name

  def initialize(name = nil)
    self.name = name
  end

  def self.all
    Database.execute("select name from goals order by name ASC").map do |row|
      goal = Goal.new
      goal.name = row[0]
      goal
    end
  end

  def self.count
    Database.execute("select count(id) from goals")[0][0]
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
    Database.execute("INSERT INTO goals (name) VALUES (?)", name)
    @id = Database.execute("SELECT last_insert_rowid()")[0]['last_insert_rowid()']
  end
end