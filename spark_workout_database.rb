require 'mongo'

include Mongo

class SparkWorkoutDatabase
	# Inserts a routine document
	def insert_routine(date, type, name)
		mongo_client = MongoClient.new("localhost")
		database = mongo_client.db("SPARKWORKOUT")
		routines_collection = database["ROUTINES"]
		
		routine_document = {"DATE" => date,
		"TYPE" => type,
		"NAME" => name}
			
		return routines_collection.insert(routine_document)
	end
	
	# Inserts an exercise document
	def insert_exercise(routine_id, type, name, number_of_reps, weight)
		mongo_client = MongoClient.new("localhost")
		database = mongo_client.db("SPARKWORKOUT")
		exercise_collection = database[type + "_" + name]
		
		exercise_document = {"ROUTINE_ID" => routine_id,		
			"NUM_REPS" => number_of_reps, 
			"WEIGHT" => weight}
			
		exercise_collection.insert(exercise_document)
	end
	
	# Retrieves the most recent exercise routine for a given exercise
	def get_last_routine(type = '', name = '')
		mongo_client = MongoClient.new("localhost")
		database = mongo_client.db("SPARKWORKOUT")

		# If no type or name were provided, retrieve the last routine entered
		if (type.nil? or type.empty? or name.nil? or name.empty?)
			last_routine_document = database["ROUTINES"].find().sort("_id" => -1).limit(1).first()
			type = last_routine_document["TYPE"]
			name = last_routine_document["NAME"]
		else
			# Get the highest routine ID from the routines collection for that type and name
			last_routine_document = 
				database["ROUTINES"].find("TYPE" => type, "NAME" => name).sort("_id" => -1).limit(1).first()
		end

		# Retrieve all records from the collection that have that routine ID and sort in ascending order
		exercise_collection = database[type + "_" + name]
		exercise_result_cursor = exercise_collection.find("ROUTINE_ID" => last_routine_document["_id"]).sort("_id" => 1)
		
		exercise_result_array = {}

		exercise_result_cursor.each { |row| 
			id = row.delete("_id"); 
			exercise_result_array["#{id}"] = row 
		}

		exercise_result_array["TYPE"] = type
		exercise_result_array["NAME"] = name
		
		return exercise_result_array
	end
end