require 'logger'
require 'sinatra'
require_relative 'spark_workout_server'

#file = File.open('spark_workout.log', File::WRONLY | File::APPEND | File::CREAT)
#logger = Logger.new(file, 5, 1024000)
# TODO i can't figure out how to get the logger to write to the specified file so for now we will just use STDOUT
logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

get '/get_last_routine' do
	logger.debug('get_last_routine') { 'BEGIN' }

	begin
		# matches "GET /get_last_routine?type=<some type>&name=<some name>"
		type = params[:type]
		name = params[:name]

		# Replace any url entities with valid characters
		type = type.tr('%20', ' ')
		name = name.tr('%20', ' ')

		spark_workout_server = SparkWorkoutServer.new
		return spark_workout_server.get_last_routine(type, name)
	ensure
		logger.debug('get_last_routine') { 'END' }
	end
end

post '/insert_routine' do
	logger.debug('insert_routine') { 'BEGIN' }

	begin
		# matches "POST /insert_routine?date=<some date>&type=<some type>&name=<some name>"
		date = params[:date]
		type = params[:type]
		name = params[:name]

		spark_workout_server = SparkWorkoutServer.new
		spark_workout_server.insert_routine(date, type, name)
	ensure
		logger.debug('insert_routine') { 'END' }
	end
end