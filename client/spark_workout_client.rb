require 'date'
require_relative '../server/spark_workout_server'

def save_workout()
	spark_workout_server = SparkWorkoutServer.new

	# Get the routine information
	print "What type of workout was this? (Ex. Chest, arms, etc.) "
	type = gets

	print "What exercise was done? "
	name = gets

	# Insert a routine document
	routine_id = spark_workout_server.insert_routine(Time.now.strftime("%Y/%m/%d %H:%M"), type, name)

	if routine_id.nil?
		return puts "No routine was inserted"
	end

	anotherSet = true

	# Loop through and enter sets for this exercise
	while (anotherSet)
		print "How many reps? "
		number_of_reps = gets

		print "Weight? "
		weight = gets
		
		print "Comment? "
		comment = gets

		# Insert the exercise document
		spark_workout_server.insert_exercise_set(routine_id, type, name, number_of_reps, weight, comment)
		
		print "Enter another set? "
		answer = gets.chomp
		answer = answer.downcase
		if !['yes', 'y'].include? (answer)
			anotherSet = false
		end
	end

	view_workout(type, name)
end

def view_workout(type, name)
	spark_workout_server = SparkWorkoutServer.new

	last_routine_array = spark_workout_server.get_last_routine(type, name)

	if last_routine_array.nil? or last_routine_array.empty?
		puts "\nNo routine was found.\n"
		return
	end

	puts "\nHere's your #{last_routine_array["type"]} #{last_routine_array["name"]} routine: "

	# Remove the type and name elements from the array so they don't get used in the following loop
	last_routine_array.delete("type")
	last_routine_array.delete("name")

	last_routine_array.each do |set|
		puts "Reps: #{set[1]["num_reps"].to_s} at #{set[1]["weight"].to_s} lbs. Comment: #{set[1]["comment"]}"
	end
end

def show_all()
	spark_workout_server = SparkWorkoutServer.new

	all_routines_array = spark_workout_server.get_all_routines()

	if all_routines_array.nil? or all_routines_array.empty?
		puts "\nNo routines were found.\n"
		return
	end

	puts "\nHere's all of your routines: "

	all_routines_array.each do |routine|
		puts "Routine: #{routine["type"]} - #{routine["name"]}"
		
		# Remove the type and name elements from the array so they don't get used in the following loop
		routine.delete("type")
		routine.delete("name")

		# Loop through each set to display them
		routine.each do |set|
			puts "Reps: #{set[1]["num_reps"].to_s} at #{set[1]["weight"].to_s} lbs. Comment: #{set[1]["comment"]}"
		end
	end
end

while (true)
	puts "\nSelect an action:"
	puts "1. Save a workout"
	puts "2. View a workout"
	puts "3. View all workouts"
	puts "4. Quit"

	answer = gets.chomp
	
	case answer
	when '1'
		save_workout()
	when '2'
		view_workout(nil, nil)
	when '3'
		show_all()
	when '4'
		abort("Goodbye.")
	else
		puts "You have selected #{answer}, but that doesn't appear to be a valid option."
	end
end