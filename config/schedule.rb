every 1.minute do
  runner "DailyJob.perform_later"
end
