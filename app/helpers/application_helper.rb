module ApplicationHelper
  def print_waypoint(waypoint, index = 0, total_distance = 0, level = 1)
    out = []
    out << render('waypoint', :waypoint => waypoint, :index => index, :total_distance => total_distance)
    if next_waypoint = waypoint.to
      out << print_waypoint(next_waypoint, index += 1, total_distance += next_waypoint.distance)
    end
    raw out.join "\n"
  end
end
