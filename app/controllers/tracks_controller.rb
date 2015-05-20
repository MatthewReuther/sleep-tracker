require "highline/import"

class TracksController
  def index
    if Track.count > 0
      tracks = Track.all # All of the tracks in an array
      choose do |menu|
        menu.prompt = ""
        tracks.each do |track|
          menu.choice(track.hours_slept){ action_menu(track) }
        end
        menu.choice("Exit")
      end
    else
      say("No tracked hours of sleep found. Add hours of sleep to track.\n")
    end
  end

  def action_menu(track)
    say("Would you like to?")
    choose do |menu|
      menu.prompt = ""
      menu.choice("Edit") do
        edit(track)
      end
      menu.choice("Delete") do
        destroy(track)
      end
      menu.choice("Exit") do
        exit
      end
    end
  end

  def add(hours_slept)
    track = Track.new(hours_slept.strip)
    if track.save
      "\"#{hours_slept}\" has been added\n"
    else
      track.errors
    end
  end

  def edit(track)
    loop do
      user_input = ask("Enter new hours of sleep to track:")
      track.hours_slept = user_input.strip
      if track.save
        say("Hours tracked have been updated to: \"#{track.hours_slept}\"")
        return
      else
        say(track.errors)
      end
    end
  end
end


