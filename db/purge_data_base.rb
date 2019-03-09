#---------- METHODS ----------
def recollect_input(message = "", filter_input = ['y', 'n'])
  begin
    print message
    input = gets.chomp.downcase
  end while !(filter_input.include? input)

  return input
end

#----------------------------------------


puts "The data base has #{User.count.to_s} users and #{Micropost.count.to_s} microposts."
input = recollect_input "Are you sure you want to purge it? (y/n):"

if input == 'y'
  User.all.each {|u| u.destroy}

  if User.count == 0
    puts "Removed all users satisfactory"
  else
    puts "Something was wrong, check database..."
  end

else
  puts "Bye"
end


