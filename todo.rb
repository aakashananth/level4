require "date"
require "./connect_db.rb"
connect_db!

class Todo < ActiveRecord::Base
  def self.overdueList
    where("due_date < ?", Date.today)
  end

  def self.due_laterList
    where("due_date > ?", Date.today)
  end

  def self.due_todayList
    where("due_date= ?", Date.today)
  end

  def self.show_list
    puts "My Todo-List\n"
    puts "\nOverdue"
    puts overdueList.map { |todo| todo.to_displayable_string }
    puts "\nDue today"
    puts due_todayList.map { |todo| todo.to_displayable_string }
    puts "\nDue later"
    puts due_laterList.map { |todo| todo.to_displayable_string }
  end

  def self.add_task(task)
    Todo.create!(todo_text: newTodo[:todo_text], due_date: Date.today + newTodo[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    return todo
  end

  def to_displayable_string
    display_status = @completed ? "[X]" : "[ ]"
    display_date = self.due_today? ? " " : "#{@due_date}"
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end
end
