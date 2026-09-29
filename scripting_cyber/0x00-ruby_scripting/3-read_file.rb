#!/usr/bin/env ruby
require "json"
def read_file(path)
  file = File.open(path)
  return file.read
end

def count_user_ids(path)
  my_json = JSON.parse(read_file(path))
  user_ids = {}
  my_json.each do |obj|
    userId = obj["userId"]
    if user_ids[userId] == nil
      user_ids[userId] = 1
    else
      user_ids[userId] += 1
    end
  end
  user_ids.each do |key, value|
    puts "#{key}: #{value}"
  end
  return nil
end
