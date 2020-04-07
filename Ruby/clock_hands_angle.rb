
#Given a time, calculate the angle between the hour and minute hands

def time_angle(current_hour, current_minute)
  minute_angle = 360*current_minute/60
  #hour_angle = 360*current_hour/60
  hour_angle = 360*(current_hour % 12)/ 12 + 360*(current_minute/60)*(1/12)
  
  puts "minute angle is #{minute_angle}"
  puts "hour angle is #{hour_angle}"
  
  #clock_hands_angle  = 360*(current_hour % 12)/ 12 + 360*(current_minute/60)*(1/12)
  clock_hands_angle = (hour_angle - minute_angle)%360
  
  puts "The angle is #{clock_hands_angle}"
end

time_angle(3, 27)