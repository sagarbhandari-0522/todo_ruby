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

  def complete_todos(todo_id)
    @client.query("update todo_tbl
      set status = 'Completed'
      where todo_id = #{todo_id};")
  end

  def delete_todos(todo_id)
    @client.query("delete from todo_tbl where todo_id=#{todo_id}")
  end

  def show_statistics
    a = @client.query("select count(*) as 'total' from todo_tbl where status='Remaining';")
    a.each do |i|
      puts "Remaining todos is #{i[:total]}"
    end
    a = @client.query("select count(*) as 'total' from todo_tbl where status='Completed';")
    a.each do |i|
      puts "Completed todos is #{i[:total]}"
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
