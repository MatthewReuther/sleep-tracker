require 'sqlite3'

class Database

  def self.load_structure
    Database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS goals (
      id integer PRIMARY KEY AUTOINCREMENT,
      name varchar(255) NOT NULL
    );
    SQL
    # Database.execute <<-SQL
    # CREATE TABLE IF NOT EXISTS dates (
    #   id integer PRIMARY KEY AUTOINCREMENT,
    #   selected_goals_id integer NOT NULL,
    #   rejected_goals_id integer NOT NULL
    # );
    # SQL
  end

  def self.execute(*args)
    initialize_database unless defined?(@@db)
    @@db.execute(*args)
  end

  def self.initialize_database
    environment = ENV["TEST"] ? "test" : "production"
    database = "db/sleep_tracker_#{environment}.sqlite"
    @@db = SQLite3::Database.new(database)
    @@db.results_as_hash = true
  end
end