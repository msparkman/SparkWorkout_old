require 'date'
require_relative 'spark_workout_server'

def save_workout()
	spark_workout_server = SparkWorkoutServer.new

	# Get the routine information
	print "What type of workout was this? (Ex. Chest, arms, etc.) "
	type = gets

	print "What exercise was done? "
	name = gets

	# Insert a routine document
	routine_id = spark_workout_server.insert_routine(Time.now.strftime("%Y/%m/%d %H:%M"), type, name)

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

	puts "\nHere's your #{last_routine_array["TYPE"]} #{last_routine_array["NAME"]} routine: "
	# Remove the type and name elements from the array so they don't get used in the following loop
	last_routine_array.delete("TYPE")
	last_routine_array.delete("NAME")

	last_routine_array.each do |exercise|
		puts "Reps: #{exercise[1]["NUM_REPS"].to_s} at #{exercise[1]["WEIGHT"].to_s} lbs."
	end
end

while (true)
	puts "\nSelect an action:"
	puts "1. Save a workout"
	puts "2. View a workout"
	puts "3. Quit"

	answer = gets.chomp
	
	case answer
	when '1'
		save_workout()
	when '2'
		view_workout(nil, nil)
	when '3'
		abort("Goodbye.")
	else
		puts "You have selected #{answer}, but that doesn't appear to be a valid option."
	end
end