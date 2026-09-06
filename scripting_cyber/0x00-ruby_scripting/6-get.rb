#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

def get_request(url)
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  
  begin
    if response.body == "{}"
      puts "{"
      puts "}"
    else
      parsed_body = JSON.parse(response.body)
      puts JSON.pretty_generate(parsed_body)
    end
  rescue JSON::ParserError
    puts response.body
  end
end
