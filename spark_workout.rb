require 'mongo'

include Mongo

class SparkWorkout
	def insertRoutine()
		# TODO need to figure out the data model
	end
	
	# TODO start with this method and work my way up
	def insertExercise(name, type, numberOfSets, numberOfReps)
		mongoClient = MongoClient.new("localhost")
		database = mongoClient.db("SPARKWORKOUT")
		exercisesCollection = database["EXERCISES"]
		
		exerciseDocument = {"NAME" => name, 
			"TYPE" => type, 
			"NUM_SETS" => numberOfSets, 
			"NUM_REPS" => numberOfReps}
		exerciseId = exercisesCollection.insert(exerciseDocument)
	end
	
	def getExercise(name, type)
		mongoClient = MongoClient.new("localhost")
		database = mongoClient.db("SPARKWORKOUT")
		exercisesCollection = database["EXERCISES"]
		
		return exerciseDocument = exercisesCollection.find({"NAME" => name, "TYPE" => type})
	end
end

sparkWorkout = SparkWorkout.new

# Check if an exercise already exists for this name and type
name = "Bench Press"
type = "Chest"
numberOfSets = 5
numberOfReps = 5
# TODO need to figure out how to check if the returned document actually contains anything
if sparkWorkout.getExercise(name, type).nil?
	sparkWorkout.insertExercise(name, type, numberOfSets, numberOfReps)
else
	puts "Exercise " + name + " already exists for " + type
end

name = "Squat"
type = "Legs"
numberOfSets = 5
numberOfReps = 5
if sparkWorkout.getExercise(name, type).nil?
	sparkWorkout.insertExercise(name, type, numberOfSets, numberOfReps)
else
	puts "Exercise " + name + " already exists for " + type
end
