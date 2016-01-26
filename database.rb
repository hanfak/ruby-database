class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
  def blue; "\e[34m#{self}\e[0m" end
end

@people =[["Entry","Surname","Forename", "Nationality", "Age", "Hobby"]]
@i=1

def fill_in_blanks entry
  entry.map! {|item_entry| item_entry=="" ? "N/A" : item_entry}
end

def add_person_details
  person =[@i]
  puts "Please add the surname of person"
  person << gets.chomp
  puts "Please add the first name of person"
  person << gets.chomp
  puts "Please add the nationality"
  person << gets.chomp
  puts "Please add the age"
  person << gets.chomp
  puts "Please add a hobby"
  person << gets.chomp
  @i+=1
  fill_in_blanks person
end

def add_person
  p @people << add_person_details
end

def display_entries (database = [])
  print "Here is a list of all the entries in the database\n\n"

  database != [] ? database : database = @people
  max_lengths = database[0].map { |word| word.length }
  database.each do |x|
    x.each_with_index do |e, i|
      s = e.size
      max_lengths[i] = s if s > max_lengths[i]
    end
  end
  database.each { |x| puts max_lengths.map { |_| "|%#{_}s" }.join(" " * 5) % x }
  puts
end

def update_person
  puts "Which entry do you want to update, choose number between 1 and #{@i-1}"
  choice = gets.chomp.to_i
  row_to_update = [@people[0]] << @people[choice]
  p display_entries row_to_update
  puts "Which item to change: (1) SURNAME, (2) FORENAME, (3) NATIONALITY, (4) AGE, or (5) HOBBY."
  puts "Choose a number"
  item = gets.chomp.to_i
  puts "To change to:"
  new_data = gets.chomp
  new_data = "N/A" if new_data == ""
  puts "Confirm update type 'y'"
  confirmation = gets.chomp
  if confirmation == "y" 
    @people[choice][item] = new_data
  elsif  confirmation == "n"
    return nil 
  else
    puts "Type y or n"
    update_person
  end
end

def delete_person
  puts "Choose entry to delete: 1 to #{@i-1}"
  entry = gets.chomp.to_i
  p display_entries [@people[0], @people[entry]] ###use display_entries
  puts "Confirm deletion: y"
  choice = gets.chomp
  @people.delete_at(entry) if choice == "y"
end


def save_database
  a = @people.collect {|element| element.join(",")}

  File.open("database.csv", "w+") do |f|
    a.each { |element| f.puts(element) }
  end
end

def load_database
   @people = File.foreach('database.csv').map { |line| line.split(' ') }.flatten.collect{|row| row.split(",")}
   @i = @people.length
end

def menu_choice
  title = "Menu"
  puts title.center(60)
  puts ("="*title.size).center(60)
  puts "1. Add a person to database".green
  puts "2. Display database".green
  puts "3. Update database".green
  puts "4. Search database (under construction)".red 
  puts "5. Delete an entry".green
  puts "6. Save database to CSV (export)".blue
  puts "7. Load database fro CSV (import)".blue
  puts "999 to exit"
  gets.chomp.to_i
end

def database
  puts "Welcome to the database. Please choose from the following options, by typing in the number and pressing enter."
  loop do
    case menu_choice
      when 1
        add_person
        display_entries
        puts "now we have #{@i-1} entries\n\n"
      when 2
        display_entries
      when 3 
        if @people.length > 1 
          update_person   
          display_entries
        else
          puts "\nNothing to update\n\n"
        end
      when 4 
        puts "Under Construction, choose another option."
      when 5
        delete_person
        display_entries if @people.length > 1  
        puts
      when 6 
        save_database
        puts "database is saved"
      when 7 
        load_database
        puts "datbase is loaded"
        display_entries
      when 999
        puts "\nThank you for using the database.\n\n"
        exit
      else
        puts "\nPlease enter an option that is available.\n\n"
    end
  end
end

database