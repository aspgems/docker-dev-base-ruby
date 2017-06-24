#!/usr/bin/ruby

castles = (ENV["CASTLES"] || '').split(',').map do |castle|
  puts "Cloning castle: #{castle}"
  `homesick clone #{castle}`
  castle_name = castle.partition('/').last
  puts "Symlinking #{castle_name}"
  `homesick symlink --force=true #{castle_name}`
end

