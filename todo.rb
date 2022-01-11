#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mysql2'
require 'date'
require '/home/sagar/Todo_Application/todo_class'
# class TODO

a = TODO.new
puts "\n"
loop do
  option = a.help
  case option.to_i
  when 1
    puts 'Enter a todo'
    todo = gets.chomp
    puts 'Enter a date to be completed'
    date = gets.chomp
    a.add_todos(todo, date)
  when 2
    a.remaining_todos
  when 3
    puts 'Enter a todos_id to be deleted'
    a.all_todos
    id = gets.chomp
    a.delete_todos(id)
  when 4
    puts 'Enter a todos_id of completed todo'
    id = gets.chomp
    a.complete_todos(id)
  when 5
    a.show_statistics
  else
    puts 'inavlid options'
  end
  puts 'Do you want to continue Y/N'
  c = gets.chomp.upcase
  break if c != 'Y'
end
puts 'Thanks for Use app'
