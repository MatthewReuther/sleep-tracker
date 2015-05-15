require "highline/import"

class GoalsController
  def index
    if Goal.count > 0
      goals = Goal.all # All of the goals in an array
      goals_string = ""
      goals.each_with_index do |goal, index|
        goals_string << "#{index + 1}. #{goal.name}\n" #=> 1. six
      end
      goals_string
    else
      "No goals found. Add a goal.\n"
    end
  end

  def add(name)
    name_cleaned = name.strip
    goal = Goal.new(name_cleaned)
    if goal.save
      "\"#{name}\" has been added\n"
    else
      goal.errors
    end
  end
end

