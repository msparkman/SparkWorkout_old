require 'mongo'

include Mongo

# A class for interacting with the SparkWorkout mongodb
class SparkWorkoutDatabase
	#@@database_url = "mongodb://msparkman:msparkman@ds039960.mongolab.com:39960/sparkworkout"
	@@database_url = "localhost"
	@@debug_mode = true

	# Returns a user's user_id
	def insert_user(username, password, date_created)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		users_collection = database["users"]

		user_document = {"username" => username,
						 "password" => password,
						 "date_created" => date_created}
			
		return users_collection.insert(user_document)
	end	

	# Returns a user's user_id
	def get_user_id(username)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		users_collection = database["users"]

		# Query by username and only return the document ID
		user_document = users_collection.find({"username" => username}, {:fields => ["_id"]}).limit(1).first()

		if user_document.nil? or user_document.empty?
			return nil
		else
			return user_document["_id"]
		end
	end

	# Returns a user's user_id
	def get_user_information(username)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		users_collection = database["users"]

		# Query by username and only return the document ID
		user_document = users_collection.find("username" => username).limit(1).first()

		if user_document.nil? or user_document.empty?
			return nil
		else
			return user_document
		end
	end

	# Inserts a routine document
	def insert_routine(user_id, date, type, name)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		routines_collection = database["routines"]
		
		routine_document = {"user_id" => user_id,
							"date" => date,
							"type" => type,
							"name" => name}
			
		return routines_collection.insert(routine_document)
	end
	
	# Inserts an exercise document
	def insert_exercise_set(routine_id, number_of_reps, weight, comment)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		exercise_collection = database["sets"]
		
		exercise_document = {"routine_id" => routine_id,		
							 "num_reps" => number_of_reps, 
							 "weight" => weight,
							 "comment" => comment}
			
		exercise_collection.insert(exercise_document)
	end
	
	# Retrieves the most recent exercise routine for the given user ID and exercise
	def get_last_routine(user_id, type, name)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		routines_collection = database["routines"]

		# If no type or name were provided, retrieve the last routine entered for the user
		if type.nil? or type.empty? or name.nil? or name.empty?
			last_routine_document = routines_collection.find("user_id" => user_id).sort("_id" => -1).limit(1).first()
			# If no routine is found, return
			if last_routine_document.nil? or last_routine_document.empty?
				return nil
			end

			type = last_routine_document["type"]
			name = last_routine_document["name"]
		else
			# Get the highest routine ID from the routines collection for the user, type and name
			last_routine_document = 
				routines_collection.find("user_id" => user_id, "type" => type, "name" => name).sort("_id" => -1).limit(1).first()
		end

		exercise_result_array = {}

		exercise_collection = database["sets"]

		# Return the empty array since no routine or collection was found for that type and name
		if last_routine_document.nil? or exercise_collection.nil?
			return exercise_result_array
		end

		# Retrieve all records from the collection that have that routine ID and sort in ascending order
		exercise_result_cursor = exercise_collection.find("routine_id" => last_routine_document["_id"]).sort("_id" => 1)

		# Loop through each document to populate the array being returned
		exercise_result_cursor.each do |row| 
			id = row.delete("_id"); 
			exercise_result_array["#{id}"] = row 
		end

		# Add in the type and name
		exercise_result_array["type"] = type
		exercise_result_array["name"] = name
		
		return exercise_result_array
	end

	# Retrieves all exercise routines for a given user
	def get_all_routines(user_id)
		mongo_client = MongoClient.from_uri(@@database_url)
		database = mongo_client.db("sparkworkout")
		routines_collection = database["routines"]
		sets_collection = database["sets"]

		# Grab all the routines for the given user ID in descending order
		all_routines_cursor = 
				routines_collection.find("user_id" => user_id).sort("_id" => -1)

		all_routines_array = Array.new

		all_routines_cursor.each do |routine_row|
			# Grab all the sets for this routine
			sets_result_cursor = sets_collection.find("routine_id" => routine_row["_id"]).sort("_id" => 1)

			sets_result_array = {}

			# Loop through each document to populate the array being returned
			sets_result_cursor.each do |row| 
				id = row.delete("_id"); 
				sets_result_array["#{id}"] = row 
			end

			# Add in the type, name, and date
			sets_result_array["type"] = routine_row["type"]
			sets_result_array["name"] = routine_row["name"]
			sets_result_array["date"] = routine_row["date"]

			all_routines_array.push(sets_result_array)			
		end

		return all_routines_array
	end
end
