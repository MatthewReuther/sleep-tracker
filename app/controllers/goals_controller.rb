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
    unless /^\d+$/.match(name_cleaned)
      Goal.create(name_cleaned)
      name_cleaned
    end
  end
end

