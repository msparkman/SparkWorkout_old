require 'bcrypt'
require_relative 'spark_workout_database'

# A class for handling the server-side logic as well as the direct accessor to the database methods
class SparkWorkoutServer
	# Register a new user
	def register(username, password, date_created)
		# Validate the parameters
		if username.nil? or username.empty? or password.nil? or password.empty?
			raise ArgumentError, "Invalid username and/or password."
		end

		username = username.downcase

		# Check if the user already exists and reject if so
		if (user_exists(username))
			raise "User already exists."
		else
			# Get the hash of the password
			password_hash = BCrypt::Password.create(password)

			spark_workout_database = SparkWorkoutDatabase.new
			return spark_workout_database.insert_user(username, password_hash, date_created)
		end
	end

	# Check if a username already exists
	def user_exists(username)
		spark_workout_database = SparkWorkoutDatabase.new

		# Get a user's user_id
		if spark_workout_database.get_user_id(username).nil?
			return false
		else
			return true
		end		
	end

	def login(username, password)
		# Validate the parameters
		if username.nil? or username.empty? or password.nil? or password.empty?
			raise ArgumentError, "Invalid username and/or password."
		end

		# Pull the user details
		spark_workout_database = SparkWorkoutDatabase.new

		# Get a user's information
		user_document = spark_workout_database.get_user_information(username)

		if user_document.nil?
			return nil
		end

		# Check if the passwords match
		if BCrypt::Password.new(user_document["password"]) == password
			return user_document["_id"]
		else
			return nil
		end
	end

	# Sends a routine to be inserted in the database
	def insert_routine(user_id, date, type, name)
		reject_if_missing_user(user_id)

		# Validate parameters
		if date.nil? or type.nil? or type.empty? or name.nil? or name.empty?
			raise ArgumentError, "Incorrect date or user input."
		end

		# Modify the given information for database use
		type = type.chomp
		type = type.downcase.tr(' ', '_')
		name = name.chomp
		name = name.downcase.tr(' ', '_')

		spark_workout_database = SparkWorkoutDatabase.new

		# Insert a routine document and return its Document ID from the database
		return spark_workout_database.insert_routine(user_id, date, type, name)
	end

	# Sends an exercise to be inserted in the database
	def insert_exercise_set(routine_id, number_of_reps, weight, comment)
		# Validate parameters
		if routine_id.nil? or number_of_reps.nil? or number_of_reps.to_i < 0 or weight.nil? or 
			weight.to_i < 1 or comment.nil? or comment.empty?
			raise ArgumentError, "Incorrect routine ID, date, or user input."
		end

		# Modify the given information for database use
		type = type.chomp
		type = type.downcase.tr(' ', '_')
		name = name.chomp
		name = name.downcase.tr(' ', '_')
		number_of_reps = number_of_reps.chomp
		weight = weight.chomp
		comment = comment.chomp

		spark_workout_database = SparkWorkoutDatabase.new

		# Insert a routine document and return its Document ID from the database
		return spark_workout_database.insert_exercise_set(routine_id, number_of_reps, weight, comment)
	end

	# Retrieves the information regarding the last routine entered for a given type and name from the database
	def get_last_routine(user_id, type = '', name = '')
		reject_if_missing_user(user_id)

		# Modify the given information for database use
		if !type.nil? and !type.empty?
			type = type.chomp
			type = type.downcase.tr(' ', '_')
		end

		if  !name.nil? and !name.empty?
			name = name.chomp
			name = name.downcase.tr(' ', '_')
		end

		spark_workout_database = SparkWorkoutDatabase.new

		# Return an array containing the last routine's workout information
		return spark_workout_database.get_last_routine(user_id, type, name)
	end

	def get_all_routines(user_id)
		reject_if_missing_user(user_id)

		spark_workout_database = SparkWorkoutDatabase.new

		# Return an array containing all the routines' workout information
		return spark_workout_database.get_all_routines(user_id)
	end

	def reject_if_missing_user(user_id)
		raise ArgumentError, "No user given" if user_id.nil?
	end
end
