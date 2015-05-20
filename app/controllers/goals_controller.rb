require "highline/import"

class GoalsController
  def index
    if Goal.count > 0
      goals = Goal.all # All of the goals in an array
      choose do |menu|
        menu.prompt = ""
        goals.each do |goal|
          menu.choice(goal.name){ action_menu(goal) }
        end
        menu.choice("Exit")
      end
    else
      say("No goals found. Add a goal.\n")
    end
  end

  def action_menu(goal)
    say("Would you like to?")
    choose do |menu|
      menu.prompt = ""
      menu.choice("Edit") do
        edit(goal)
      end
      menu.choice("Delete") do
        destroy(goal)
      end
      menu.choice("Exit") do
        exit
      end
    end
  end

  def add(name)
    goal = Goal.new(name.strip)
    if goal.save
      "\"#{name}\" has been added\n"
    else
      goal.errors
    end
  end

  def edit(goal)
    loop do
      user_input = ask("Enter a new name:")
      goal.name = user_input.strip
      if goal.save
        say("goal has been updated to: \"#{goal.name}\"")
        return
      else
        say(goal.errors)
      end
    end
  end
end


