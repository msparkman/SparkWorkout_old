require 'date'
require_relative 'spark_workout_database'

# TODO need to figure out why this is always aborting even if you say 'yes'
#print "Would you like to save a workout today? "
#answer = gets
#answer = answer.downcase
# If the user inputs anything other than 'yes' or 'y', quit
#if !['yes', 'y'].include? (answer)
#	abort("So be it. Farewell.")
#end

# TODO 1. Insert a new routine document. Keep its ID to use as a foreign key for the exercise's sets.
# TODO 2. What exercise the user performed
# TODO 3. Start the first set. Ask how many reps were done and at what weight
# TODO 4. Start a loop asking each time "Did you do another set?" If so, ask the same stuff and store for each

spark_workout_database = SparkWorkoutDatabase.new

# TODO have these be filled by user input and also sanitize them all
type = "chest"
type = type.upcase.tr(' ', '_')
name = "bench press"
name = name.upcase.tr(' ', '_')
number_of_reps = 5
weight = 165

# Insert a routine document
routine_id = spark_workout_database.insert_routine(Time.now.strftime("%Y/%m/%d %H:%M"), type, name)

# Insert the exercise document
spark_workout_database.insert_exercise(routine_id, type, name, number_of_reps, weight)

# TODO this is just a test to display the workout that was entered
last_routine_array = spark_workout_database.get_last_routine(type, name)
puts "Here's your " + type + " " + name + " routine: "
last_routine_array.each do |exercise|
	puts "Reps: " + exercise[1]["NUM_REPS"].to_s + " at " + exercise[1]["WEIGHT"].to_s + " lbs."
end