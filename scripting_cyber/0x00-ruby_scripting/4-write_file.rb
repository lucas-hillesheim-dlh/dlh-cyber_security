#!/usr/bin/env ruby
require 'json'

def read_file(path)
  file = File.open(path)
  return file.read
end

def write_file(path, data)
  File.write(path, data)
end

def merge_json_files(file1_path, file2_path)
  data1 = JSON.parse(read_file(file1_path))
  data2 = JSON.parse(read_file(file2_path))
  
  data_merged = data1 + data2

  json_merged = JSON.generate(data_merged)
  write_file(file2_path, json_merged)
end
