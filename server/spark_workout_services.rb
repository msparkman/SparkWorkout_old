require 'date'
require 'logger'
require 'sinatra'
require_relative 'spark_workout_server'

# Log out to the terminal
logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

get '/' do
	erb :index
end

get '/get_last_routine' do
	METHOD_NAME = 'get_last_routine'
	logger.debug(METHOD_NAME) { 'BEGIN' }

	begin
		# matches "GET /get_last_routine?type=<some type>&name=<some name>"
		type = params[:type]
		name = params[:name]

		# Replace any url entities with valid characters
		HTML_SPACE = '%20'
		type = type.tr(HTML_SPACE, ' ')
		name = name.tr(HTML_SPACE, ' ')

		spark_workout_server = SparkWorkoutServer.new
		return spark_workout_server.get_last_routine(type, name)
	ensure
		logger.debug(METHOD_NAME) { 'END' }
	end
end

post '/save_workout' do
	METHOD_NAME = 'save_workout'
	logger.debug(METHOD_NAME) { 'BEGIN' }

	begin
		# matches "POST /save_workout"
		type = params[:type]
		name = params[:name]
		set_array = params[:set_array]

		# Insert the routine
		spark_workout_server = SparkWorkoutServer.new
		routine_id = spark_workout_server.insert_routine(
			Time.now.strftime("%Y/%m/%d %H:%M"), 
			type, 
			name)

		# Insert each set
		set_array.each do |set|
			spark_workout_server.insert_exercise_set(
			routine_id, 
			type, 
			name, 
			set['number_of_reps'], 
			set['weight'], 
			set['comment'])
		end

		# Send the index page back out in case they want to enter another routine 
		erb :index
	ensure
		logger.debug(METHOD_NAME) { 'END' }
	end
end
