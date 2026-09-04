#!/usr/bin/env ruby
class HelloWorld
  attr_accessor :message

  def initialize(message = "Hello, World!")
    @message = message
  end
  def print_hello
    puts @message
  end
end
