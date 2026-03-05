# Daily at 9 AM
every :day, at: '9:00am' do
  rake "recommendations:send_daily"
end

# Weekly on Sunday at 9 AM
every :sunday, at: '9:00am' do
  rake "recommendations:send_weekly"
end

# Bi-weekly (every 2 weeks) on Sunday at 9 AM
every 2.weeks, at: '9:00am' do
  rake "recommendations:send_biweekly"
end

# Monthly on the 1st at 9 AM
every '0 9 1 * *' do
  rake "recommendations:send_monthly"
end
