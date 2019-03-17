include ActionView::Helpers::DateHelper
class Util
  def self.pretty_time(time)
    return "" if time == nil
    if time > 1.day.ago
      time_ago_in_words(time) + " ago"
    else
      time.strftime("%b %e, %Y")
    end
  end
end