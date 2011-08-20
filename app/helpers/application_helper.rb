module ApplicationHelper
  def print_waypoint(waypoint, waypoint_count = 1, total_distance = 0)
    out = []
    out << render('waypoint', :waypoint => waypoint, :waypoint_count => waypoint_count, :total_distance => total_distance)
    if next_waypoint = waypoint.to
      out << print_waypoint(next_waypoint, waypoint_count += 1, total_distance += next_waypoint.distance)
    end
    raw out.join "\n"
  end
end
