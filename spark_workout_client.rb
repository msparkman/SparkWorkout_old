require 'date'
require_relative 'spark_workout_database'

print "Would you like to save a workout today? "
answer = gets.chomp
answer = answer.downcase
 
# If the user inputs anything other than 'yes' or 'y', quit
if !['yes', 'y'].include? (answer)
	abort("Goodbye.")
end

spark_workout_database = SparkWorkoutDatabase.new

# Get the routine information
print "What type of workout was this? (Ex. Chest, arms, etc.) "
type = gets.chomp
type = type.upcase.tr(' ', '_')

print "What exercise was done? "
name = gets.chomp
name = name.upcase.tr(' ', '_')

# Insert a routine document
routine_id = spark_workout_database.insert_routine(Time.now.strftime("%Y/%m/%d %H:%M"), type, name)

anotherSet = true

# Loop through and enter sets for this exercise
while (anotherSet)
	print "How many reps? "
	number_of_reps = gets.chomp

	print "Weight? "
	weight = gets.chomp
	
	# Insert the exercise document
	spark_workout_database.insert_exercise(routine_id, type, name, number_of_reps, weight)
	
	print "Enter another set? "
	answer = gets.chomp
	answer = answer.downcase
	if !['yes', 'y'].include? (answer)
		anotherSet = false
	end
end

# TODO this is just a test to display the workout that was entered
last_routine_array = spark_workout_database.get_last_routine(type, name)
puts "\nHere's your " + type + " " + name + " routine: "
last_routine_array.each do |exercise|
	puts "Reps: " + exercise[1]["NUM_REPS"].to_s + " at " + exercise[1]["WEIGHT"].to_s + " lbs."
end