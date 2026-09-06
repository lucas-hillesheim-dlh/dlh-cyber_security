#!/usr/bin/env ruby
require 'digest'

if ARGV.length != 2
  puts "Usage: #{File.basename(__FILE__)} HASHED_PASSWORD DICTIONARY_FILE"
  exit 1
end

hashed_password = ARGV[0].downcase
dictionary_file = ARGV[1]

unless File.exist?(dictionary_file)
  puts "Password not found in dictionary."
  exit 1
end

found_password = nil

File.foreach(dictionary_file) do |line|
  word = line.chomp
  if Digest::SHA256.hexdigest(word).downcase == hashed_password
    found_password = word
    break
  end
end

if found_password
  puts "Password found: #{found_password}"
else
  puts "Password not found in dictionary."
end
