require 'rubygems'
require 'bundler/setup'
require "minitest/reporters"
Dir["./app/**/*.rb"].each { |f| require f }
Dir["./lib/*.rb"].each { |f| require f }
ENV["TEST"] = "true"

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require 'minitest/autorun'
class Minitest::Test
  def setup
    Database.load_structure
    Database.execute("DELETE FROM tracks;")
    # Database.execute("DELETE FROM dates;")
  end
end

def create_track(hours_slept)
  Database.execute("INSERT INTO tracks (hours_slept) VALUES (?)", hours_slept)
end

def exit_from(pipe)
  pipe.puts "Exit"
  pipe.puts "3"
  main_menu + "Good luck, see you soon!\n"
end

def main_menu
  "1. Add hours of sleep to track\n2. List all hours tracked\n3. Exit\n"
end

def actions_menu
  "Would you like to?\n1. Edit\n2. Delete\n3. Exit\n"
end