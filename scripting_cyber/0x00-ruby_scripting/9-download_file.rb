#!/usr/bin/env ruby
require 'open-uri'
require 'uri'
require 'fileutils'

if ARGV.length != 2
  puts "Usage: #{File.basename(__FILE__)} URL LOCAL_FILE_PATH"
  exit 1
end

url = ARGV[0]
file_path = ARGV[1]

# Ensure the destination directory exists
dir_path = File.dirname(file_path)
FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

puts "Downloading file from #{url}..."

# Download and write the file locally
URI.open(url) do |stream|
  File.open(file_path, 'wb') do |file|
    file.write(stream.read)
  end
end

puts "File downloaded and saved to #{file_path}."
