#!/usr/bin/env ruby
require 'optparse'

TASKS_FILE = 'tasks.txt'

def read_tasks
  return [] unless File.exist?(TASKS_FILE)
  File.readlines(TASKS_FILE, chomp: true)
end

def write_tasks(tasks)
  File.open(TASKS_FILE, 'w') do |file|
    tasks.each { |task| file.puts(task) }
  end
end

options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", "Remove a task by index") do |index|
    options[:remove] = index.to_i
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end

parser.parse!

tasks = read_tasks

if options[:add]
  tasks << options[:add]
  write_tasks(tasks)
  puts "Task '#{options[:add]}' added."
elsif options[:list]
  if tasks.empty?
    puts "No tasks found."
  else
    tasks.each_with_index do |task, index|
      puts "#{index + 1}. #{task}"
    end
  end
elsif options[:remove]
  index = options[:remove] - 1
  if index >= 0 && index < tasks.length
    removed_task = tasks.delete_at(index)
    write_tasks(tasks)
    puts "Task '#{removed_task}' removed."
  else
    puts "Invalid index."
  end
end
