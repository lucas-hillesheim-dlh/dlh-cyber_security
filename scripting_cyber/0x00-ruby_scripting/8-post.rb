#!/usr/bin/env ruby
require 'net/http'
require 'uri'

def post_request(url, body_params = {})
  uri = URI.parse(url)
  response = Net::HTTP.post_form(uri, body_params)

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  puts response.body
end
