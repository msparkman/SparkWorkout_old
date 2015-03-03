require 'sinatra'
require_relative 'spark_workout_server'

get '/get_last_routine' do
	# matches "GET /get_last_routine?type=<some type>&name=<some name>"
	type = params[:type]
	name = params[:name]

	# Replace any url entities with valid characters
	type = type.tr('%20', ' ')
	name = name.tr('%20', ' ')

	spark_workout_server = SparkWorkoutServer.new
	last_routine_array = spark_workout_server.get_last_routine(type, name)

	# TODO the following is just to test out the web services. Normally we would just return the array back to the user to be handled
	puts "\nHere's your #{last_routine_array["TYPE"]} #{last_routine_array["NAME"]} routine: "
	# Remove the type and name elements from the array so they don't get used in the following loop
	last_routine_array.delete("TYPE")
	last_routine_array.delete("NAME")

	last_routine_array.each do |exercise|
		puts "Reps: #{exercise[1]["NUM_REPS"].to_s} at #{exercise[1]["WEIGHT"].to_s} lbs."
	end
end

post '/insert_routine' do
	# matches "POST /insert_routine?date=<some date>&type=<some type>&name=<some name>"
	date = params[:date]
	type = params[:type]
	name = params[:name]

	spark_workout_server = SparkWorkoutServer.new
	spark_workout_server.insert_routine(date, type, name)
end