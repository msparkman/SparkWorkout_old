require_relative 'spark_workout_database'

# A class for handling the server-side logic as well as the direct accessor to the database methods
class SparkWorkoutServer
	# Sends a routine to be inserted in the database
	def insert_routine(date, type, name)
		spark_workout_database = SparkWorkoutDatabase.new

		# Modify the given information for database use
		type = type.chomp
		type = type.downcase.tr(' ', '_')
		name = name.chomp
		name = name.downcase.tr(' ', '_')

		# Insert a routine document and return its Document ID from the database
		return spark_workout_database.insert_routine(date, type, name)
	end

	# Sends an exercise to be inserted in the database
	def insert_exercise_set(routine_id, type, name, number_of_reps, weight, comment)
		spark_workout_database = SparkWorkoutDatabase.new

		# Modify the given information for database use
		type = type.chomp
		type = type.downcase.tr(' ', '_')
		name = name.chomp
		name = name.downcase.tr(' ', '_')
		number_of_reps = number_of_reps.chomp
		weight = weight.chomp
		comment = comment.chomp

		# Insert a routine document and return its Document ID from the database
		return spark_workout_database.insert_exercise_set(routine_id, type, name, number_of_reps, weight, comment)
	end

	# Retrieves the information regarding the last routine entered for a given type and name from the database
	def get_last_routine(type = '', name = '')
		spark_workout_database = SparkWorkoutDatabase.new

		# Modify the given information for database use
		if !type.nil? and !type.empty?
			type = type.chomp
			type = type.downcase.tr(' ', '_')
		end

		if  !name.nil? and !name.empty?
			name = name.chomp
			name = name.downcase.tr(' ', '_')
		end

		# Return an array containing the last routine's workout information
		return spark_workout_database.get_last_routine(type, name)
	end

	def get_all_routines()
		spark_workout_database = SparkWorkoutDatabase.new

		# Return an array containing all the routines' workout information
		return spark_workout_database.get_all_routines()
	end
end
