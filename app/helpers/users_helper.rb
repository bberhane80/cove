module UsersHelper
  def frequency_icon(frequency)
    case frequency
    when 'daily'
      'calendar-day'
    when 'weekly'
      'calendar-week'
    when 'biweekly'
      'calendar2-week'
    when 'monthly'
      'calendar-month'
    else
      'envelope'
    end
  end

  def frequency_description(frequency)
    case frequency
    when 'daily'
      'Get fresh recommendations every day'
    when 'weekly'
      'Perfect for staying up-to-date'
    when 'biweekly'
      'Bi-weekly digest of new listings'
    when 'monthly'
      'Monthly curated selections'
    else
      ''
    end
  end
end
