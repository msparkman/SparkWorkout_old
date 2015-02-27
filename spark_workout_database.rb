require 'mongo'

include Mongo

class SparkWorkoutDatabase
	# Inserts an exercise document into the database
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
	
	# Retrieves an exercise document from the database
	def get_exercise(name, type)
		mongo_client = MongoClient.new("localhost")
		database = mongo_client.db("SPARKWORKOUT")
		exercises_collection = database["EXERCISES"]
		
		# Use find_one in order to return a single document instead of a cursor
		return exercises_collection.find_one("NAME" => name, "TYPE" => type)
		
		# TODO if I wanted to return a cursor, I would need to perform the .each method and throw each "row" into an array element, etc. like this: 
		# result = {}
		# exercises_collection.find().each { |row| id = row.delete('id'); result["#{id}"] = row }
	end
end