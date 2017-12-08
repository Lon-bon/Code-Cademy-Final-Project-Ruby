module Menu
    def menu
        "
        1) Add
        2) Show
        3) Update
        4) Delete
        5) Write to a File
        6) Read from a File
        7) Toggle Status
        Q) Quit"
    end
    def show
        menu
    end
end

module Promptable
    def prompt(message = "What would you like to do?", symbol = " :> ")
        print message
        print symbol
        gets.chomp.strip
    end
end

class List
    attr_reader :all_tasks
    def initialize
        @all_tasks = []
    end
    def add(task)
        all_tasks << task
    end
    def show
       all_tasks.map.with_index { |task, n| puts "#{n.next}) #{task}" }
    end
    def write_to_file(file)
        IO.write(file, @all_tasks.map(&:to_machine).join("\n"))
    end
    def read_from_file(file)
        IO.readlines(file).each { |line| 
            status, *description = line.split(":")
            status = status.downcase.include?("x")
            add(Task.new(description.join(":").strip, status)) }
    end
    def delete(task_number)
        all_tasks.delete_at(task_number - 1)
    end
    def update(task_number, task)
        all_tasks[task_number - 1] = task
    end
    def toggle(task_number)
        all_tasks[task_number - 1].toggle_status
    end
end

class Task
    attr_reader :description
    attr_accessor :status
    def initialize(description, status = false)
        @description = description
        @status = status
    end
    def to_s
        "#{represent_status}: #{description}"
    end
    def completed?
        status
    end
    private
    def represent_status
        completed? ? '[X]' : '[ ]'
    end
    public
    def to_machine
        "#{represent_status}: #{description}"
    end
    def toggle_status
        @status = !completed?
    end
end

if __FILE__ == $PROGRAM_NAME
    include Menu
    include Promptable
    my_list = List.new
    puts "Please choose from the following list: "
    until ["q"].include?(user_input = prompt(show).downcase)
        case user_input
            #add
            when "1"
                my_list.add(Task.new(prompt("What task would you like to add?")))
            #show
            when "2"
                puts my_list.show
            when "3"
                puts my_list.show
                my_list.update(prompt("Enter the number of the task that you want to update.").to_i, Task.new(prompt("What is the new task?")))
            when "4"
                puts my_list.show
                my_list.delete(prompt("Enter the number of the task that you want to delete.").to_i)
            when "5"
                my_list.write_to_file(prompt("What file would you like to write to?"))
            when "6"
                begin
                    my_list.read_from_file(prompt("What file do you want to read from"))
                rescue Errno::ENOENT
                    puts "Invalid filename. Please enter a filename that exist and verify that the file path is correct"
                end
            when "7"
                puts my_list.show
                my_list.toggle(prompt("Enter the number of the task that you want to toggle status of.").to_i)
            else 
                puts "Invalid Input..."
        end
    end
    puts "Thanks for using this menu system!"
end
