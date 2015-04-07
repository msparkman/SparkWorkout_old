require 'date'
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

get '/' do
	if settings.user_id.nil?
		# Send the user to the login page
		erb :login
	else
		begin
			username = params[:username]
			password = params[:password]

			# See if the user exists and if so, set the instance user_id
			spark_workout_server = SparkWorkoutServer.new
			temp_user_id = spark_workout_server.login(username, password)

			if temp_user_id.nil?
				raise "Invalid user credentials"
			else
				settings.user_id = temp_user_id
			end

			# Send the user to the home page
			erb :index
		rescue
			erb :login
		end
	end
end

get '/login' do
	erb :login
end

post '/register' do
	settings.METHOD_NAME = 'register'
	logger.debug(settings.METHOD_NAME) { 'BEGIN'}

	begin
		username = params[:username]
		password = params[:password]

		spark_workout_server = SparkWorkoutServer.new
		temp_user_id = spark_workout_server.register(username, 
													 password,
													 Time.now.strftime("%Y/%m/%d %H:%M"))

		# If the user wasn't registered for some reason, send them back to the login
		if temp_user_id.nil?
			raise "Unable to register the user. Please contact a github contributor for this project.<br />"
		else
			settings.user_id = temp_user_id
			erb :index
		end
	rescue Exception => @e
		erb :login
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

		temp_user_id = spark_workout_server.login(username, password)

		if temp_user_id.nil?
			raise "Unable to login. The username and/or password are incorrect."
		else
			settings.user_id = temp_user_id
			erb :index
		end
	rescue Exception => @e
		erb :login
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

		spark_workout_server = SparkWorkoutServer.new
		return spark_workout_server.get_last_routine(settings.user_id, type, name)
	rescue Exception => @e
		erb :index
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

		# Send the index page back out in case they want to enter another routine 
		erb :index
	rescue Exception => @e
		erb :index
	ensure
		logger.debug(settings.METHOD_NAME) { 'END' }
	end
end