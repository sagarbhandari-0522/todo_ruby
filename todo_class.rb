# frozen_string_literal: true

# class TODO
class TODO
  attr_accessor :client, :users

  def initialize
    @client = Mysql2::Client.new(
      host: 'localhost',
      database: 'TODO',
      username: 'root',
      password: 'password'
    )
    @users = client.query('select * from login')
  end

  def authentication
    attempt = 3
    check = 'success'
    while attempt.positive?
      puts 'Enter login credintials'
      print "Username:\t"
      username = gets.chomp.to_s
      print "Password:\t"
      password = gets.chomp.to_s
      users.each do |user|
        check = 'success'
        break if user['username'] == username && user['password'] == password

        check = 'wrong'
      end
      puts
      case check
      when 'success'
        puts 'You are loged in'
      when 'wrong'
        puts 'You enter the wrong credintials'
      end
      break if check == 'success'

      attempt -= 1

    end
    case check
    when 'success'
      check
    when 'wrong'
      puts 'You enter the wrong passoword 3 times'
      print 'Do you want to continue Y/N  '
      c = gets.chomp.upcase
      if c == 'Y'
        authentication
      else
        check
      end
    end
  end

  def add_todos
    date_lambda = lambda {
      puts 'Enter a date to be completed'
      date = gets.chomp
      date = Date.parse(date)
      now = Time.now.to_date
      remaining_days = (date.mjd - now.mjd).to_i
      puts date, remaining_days
      if remaining_days.negative?
        puts 'You enter wrong date ie already passed'
        puts 'Re-enter date'
        date = date_lambda.call
        return date
      end

      return date, remaining_days
    }
    puts 'Enter a todo'
    todo = gets.chomp
    date = date_lambda.call
    date_completed = date[0]
    remaining_days = date[1]

    client.query("insert into todo_tbl(todo,date_to_be_completed,remaining_days)
          values('#{todo}','#{date_completed}',#{remaining_days});")
    puts 'TODOS Added'
  end

  def add_user
    print 'Enter username: '
    username = gets.chomp
    print 'Enter the password: '
    password = gets.chomp
    client.query("insert into login(username,password)
    values('#{username}','#{password}')")
    puts 'User added'
    self.users = client.query('select * from login')
  end

  def complete_todos(todo_id)
    client.query("update todo_tbl
      set status = 'Completed'
      where todo_id = #{todo_id};")
  end

  def delete_todos
    a = []
    puts 'Enter a todos_id to be deleted'
    id = gets.chomp.to_i
    all_id = client.query('select todo_id from todo_tbl')
    all_id.each do |ids|
      a.push(ids['todo_id'])
    end
    if a.include?(id)
      client.query("delete from todo_tbl where todo_id=#{id}")
      puts 'TODOS deleted'
    else
      puts "You enter the wrong todo id\nplease enter new one"
      delete_todos
    end
  end

  def show_statistics
    a = client.query("select count(*) as 'total' from todo_tbl where status='Remaining';")
    a.each do |i|
      puts "Remaining todos is #{i['total']}"
    end
    a = client.query("select count(*) as 'total' from todo_tbl where status='Completed';")
    a.each do |i|
      puts "Completed todos is #{i['total']}"
    end
  end

  def help
    print %(
        Select :-
          1. Add a new todo
          2. Show remaining todos
          3. Delete a todo
          4. Complete a todo
          5. Statistics
          6.Add User
          7.Search TOdos
    Enter the Options:-)
    gets.chomp
  end

  def all_todos
    todos = client.query('select * from todo_tbl')
    puts('Todo_id Todos Date to be completed Remaining Days')
    todos.each do |i|
      # puts i['task_id']
      puts "#{i['todo_id']}\t #{i['todo']}\t#{i['date_to_be_completed']}\t#{i['remaining_days']} \t #{i['status']}"
    end
  end

  def remaining_todos
    todos = client.query('select * from todo_tbl where status="Remaining" order by remaining_days ASC')
    todos.each do |i|
      # puts i['task_id']
      puts "#{i['todo_id']}\t #{i['todo']}\t#{i['date_to_be_completed']}\t#{i['remaining_days']} \t #{i['status']}"
    end
  end

  def search_todos
    print 'Enter the keyword to be search '
    key = gets.chomp
    todos = client.query("select * from todo_tbl where todo like '%#{key}%' order by remaining_days ASC")
    todos.each do |todo|
      puts "#{todo['todo_id']}\t #{todo['todo']}\t#{todo['date_to_be_completed']}\t#{todo['remaining_days']} \t #{todo['status']}"
    end
  end
end
