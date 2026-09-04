#!/usr/bin/env ruby
require "json"
def read_file
  file = File.open(path)
  return file.read
end

def count_user_ids(path)
  my_json = JSON.parse(read_file(path))
  user_ids = {}
  my_json.each do |obj|
    user_ids[obj["userId"]] += 1
  puts user_ids
  end
end
