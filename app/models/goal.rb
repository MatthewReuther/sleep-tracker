class Goal
  attr_accessor :name

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

  def self.create(name)
    if name.empty?
      raise ArgumentError.new
    else
      Database.execute("INSERT INTO goals (name) VALUES (?)", name)
    end
  end
end