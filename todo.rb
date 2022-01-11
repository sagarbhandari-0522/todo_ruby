#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mysql2'
require 'date'
require '/home/sagar/Todo_Application/todo_class'

a = TODO.new
auth = a.authentication
if auth == 'success'
  loop do
    option = a.help
    case option.to_i
    when 1
      begin
        a.add_todos
      rescue StandardError => e
        puts e.message
        retry
      end
    when 2
      begin
        a.remaining_todos
      rescue StandardError => e
        puts e.message
        retry
      end
    when 3
      begin
        a.all_todos
        a.delete_todos
      rescue StandardError => e
        puts e.message
        retry
      end
    when 4
      begin
        puts 'Enter a todos_id of completed todo'
        id = gets.chomp
        a.complete_todos(id)
      rescue StandardError => e
        puts e.message
        retry
      end
    when 5
      begin
        a.show_statistics
      rescue StandardError => e
        puts e.message
        retry
      end
    when 6
      begin
        a.add_user
      rescue StandardError => e
        puts e.message
        retry
      end
    else
      puts 'inavlid options'
    end
    puts 'Do you want to continue Y/N'
    c = gets.chomp.upcase
    break if c != 'Y'
  end
else
  puts 'Thanks for using app'
end
puts 'Thanks for using app'
