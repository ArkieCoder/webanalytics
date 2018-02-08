require 'bundler' ; Bundler.require
require './models'
MILLS_PER_HR = 3600000

before do
  content_type 'application/json'
  Encoding.default_external = 'UTF-8'
end

post '/analytics' do
  timestamp=params[:timestamp]
  user=params[:user]
  event=params[:event]
  analytic = Analytic.new(ts: timestamp.to_i, user: user, event: event)
  if event == "click" || event == "impression"
    analytic.save
  end

  http_status = analytic.persisted? ? 204 : 500
  status http_status
end

get '/analytics' do
  timestamp=params[:timestamp]
  time_start_of_hour = (timestamp.to_i/MILLS_PER_HR)*MILLS_PER_HR
  time_end_of_hour = time_start_of_hour + MILLS_PER_HR - 1
  analytics_in_time_range = Analytic.where("ts BETWEEN ? AND ?", time_start_of_hour, time_end_of_hour)
  unique_user_count = analytics_in_time_range.distinct.count("user")
  click_count = analytics_in_time_range.where(event: "click").count
  impression_count = analytics_in_time_range.where(event: "impression").count
  "unique_users,#{unique_user_count}\nclicks,#{click_count}\nimpressions,#{impression_count}\n"
end

