#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mysql2'
require 'date'
# class TODO
class TODO
  def initialize
    @client = Mysql2::Client.new(
      host: 'localhost',
      database: 'TODO',
      username: 'root',
      password: 'password'
    )
  end

  def add_todos(todo, date)
    date1 = Date.parse(date)
    now = Time.now.to_date
    remaining_days = (date1.mjd - now.mjd).to_i
    @client.query("insert into todo_tbl(todo,date_to_be_completed,remaining_days)
   values('#{todo}','#{date1}',#{remaining_days});")
    puts 'TODOS Added'
  end

  def complete_todos(todoid)
    @client.query("update todo_tbl
    set status = 'Completed'
    where todo_id = #{todoid};")
  end

  def delete_todos(todoid)
    @client.query("delete from todo_tbl where todo_id=#{todoid}")
  end

  def statistics
    a = @client.query("select count(*) as 'total' from todo_tbl where status='Remaining';")
    a.each do |i|
      puts "Remaining todos is #{i.fetch('total')}"
    end
    a = @client.query("select count(*) as 'total' from todo_tbl where status='Completed';")
    a.each do |i|
      puts "Completed todos is #{i.fetch('total')}"
    end
  end

  def help
    puts %(
      Select :-
        1. Add a new todo
        2. Show remaining todos
        3. Delete a todo
        4. Complete a todo
        5. Statistics
  Enter the Options:-)
    gets.chomp
  end

  def all_todos
    todos = @client.query('select * from todo_tbl')
    puts('Todo_id Todos Date to be completed Remaining Days')
    todos.each do |i|
      # puts i['task_id']
      puts "#{i['todo_id']}\t #{i['todo']}\t#{i['date_to_be_completed']}\t#{i['remaining_days']} \t #{i['status']}"
    end
  end

  def remaining_todos
    todos = @client.query("select * from todo_tbl where status='Remaining'")
    todos.each do |i|
      # puts i['task_id']
      puts "#{i['todo_id']}\t #{i['todo']}\t#{i['date_to_be_completed']}\t#{i['remaining_days']} \t #{i['status']}"
    end
  end
end
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
    a.statistics
  else
    puts 'inavlid options'
  end
  puts 'Do you want to continue Y/N'
  c = gets.chomp.upcase
  break if c != 'Y'
end
puts 'Thanks for Use app'
