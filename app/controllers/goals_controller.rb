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
end

