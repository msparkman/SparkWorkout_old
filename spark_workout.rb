require 'mongo'

include Mongo

class SparkWorkout
	# TODO start with this method and work my way up
	def insert_exercise(name, type, number_of_sets, number_of_reps)
		mongo_client = MongoClient.new("localhost")
		database = mongo_client.db("SPARKWORKOUT")
		exercises_collection = database["EXERCISES"]
		
		exercise_document = {"NAME" => name, 
			"TYPE" => type, 
			"NUM_SETS" => number_of_sets, 
			"NUM_REPS" => number_of_reps}
			
		exercises_collection.insert(exercise_document)
	end
	
	def get_exercise(name, type)
		mongo_client = MongoClient.new("localhost")
		database = mongo_client.db("SPARKWORKOUT")
		exercises_collection = database["EXERCISES"]
		
		# Have to use find_one in order to return a single document instead of a cursor
		return exercises_collection.find_one("NAME" => name, "TYPE" => type)
		
		# TODO if I wanted to return a cursor, I would need to perform the .each method and throw each "row" into an array element, etc. like this: 
		# result = {}
		# exercises_collection.find().each { |row| id = row.delete('id'); result["#{id}"] = row }
	end
end

spark_workout = SparkWorkout.new

# Check if an exercise already exists for this name and type
name = "Bench Press"
type = "Chest"
number_of_sets = 5
number_of_reps = 5
# TODO need to figure out how to check if the returned document actually contains anything
exercise_document = spark_workout.get_exercise(name, type)
if exercise_document.nil?
	spark_workout.insert_exercise(name, type, number_of_sets, number_of_reps)
else
	puts "Exercise " + name + " already exists for " + type
end

name = "Squat"
type = "Legs"
number_of_sets = 5
number_of_reps = 5
exercise_document = spark_workout.get_exercise(name, type)
if exercise_document.nil?
	spark_workout.insert_exercise(name, type, number_of_sets, number_of_reps)
else
	puts "Exercise " + name + " already exists for " + type
end
