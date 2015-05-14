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
    Database.load_structure
    Database.execute("DELETE FROM goals;")
  end


def create_goal(name)
  Database.execute("INSERT INTO goals (name) VALUES (?)", name)
end

def main_menu
  "1. Add a goal\n2. List all goals\n3. Exit\n"
end