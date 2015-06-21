require 'date'
require 'json'
require 'logger'
require 'sinatra'
require_relative 'spark_workout_server'

# Initialize this constant only once
set :METHOD_NAME, ""
# TODO this is to be used for testing and should be removed once multiple user support is finished
set :user_id, BSON::ObjectId("5519cc1aea2f2b13bd000001")

# Log out to the terminal
logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

post '/register' do
	settings.METHOD_NAME = 'register'
	logger.debug(settings.METHOD_NAME) { 'BEGIN' }

	begin
		username = params[:username]
		password = params[:password]

		spark_workout_server = SparkWorkoutServer.new
		return spark_workout_server.register(username, 
											 password,
											 Time.now.strftime("%Y/%m/%d %H:%M:%S")).to_json
	ensure
		logger.debug(settings.METHOD_NAME) { 'END' }
	end
end

post '/login' do
	settings.METHOD_NAME = 'login'
	logger.debug(settings.METHOD_NAME) { 'BEGIN'}

	begin
		username = params[:username]
		password = params[:password]

		spark_workout_server = SparkWorkoutServer.new

		return spark_workout_server.login(username, password).to_json
	ensure
		logger.debug(settings.METHOD_NAME) { 'END' }
	end
end

get '/get_last_routine' do
	settings.METHOD_NAME = 'get_last_routine'
	logger.debug(settings.METHOD_NAME) { 'BEGIN' }

	begin
		type = params[:type]
		name = params[:name]

		# Replace any url entities with valid characters
		HTML_SPACE = '%20'
		type = type.tr(HTML_SPACE, ' ')
		name = name.tr(HTML_SPACE, ' ')

		puts "user_id: " + settings.user_id

		spark_workout_server = SparkWorkoutServer.new
		return spark_workout_server.get_last_routine(settings.user_id, type, name).to_json
	ensure
		logger.debug(settings.METHOD_NAME) { 'END' }
	end
end

post '/save_workout' do
	settings.METHOD_NAME = 'save_workout'
	logger.debug(settings.METHOD_NAME) { 'BEGIN' }

	begin
		# TODO during development we will just use the given user_id from above
		#user_id = BSON::ObjectId(params[:user_id] )
		type = params[:type]
		name = params[:name]
		set_array = params[:set_array]

		# Insert the routine
		spark_workout_server = SparkWorkoutServer.new
		routine_id = spark_workout_server.insert_routine(
			# TODO for now, just use the default user_id
			#user_id,
			settings.user_id,
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
	ensure
		logger.debug(settings.METHOD_NAME) { 'END' }
	end
end