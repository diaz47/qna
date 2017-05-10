every 1.day do
  runner "DailyJob.perform_later"
end

every 60.minutes do
  rake "ts:index"
end

every :reboot do
  rake "ts:start"
end
