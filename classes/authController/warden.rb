# auth management using Warden. Fairly boilerplate code here.
require 'warden'
class App < Sinatra::Base

	use Warden::Manager do |manager|
		manager.default_strategies :password
		manager.failure_app = FailureApp.new
	end

	### Session Setup
	# Tell Warden how to serialize the user in and out of the session.
	Warden::Manager.serialize_into_session do |user|
		# puts '[INFO] serialize into session'
		user.user_id
	end

	Warden::Manager.serialize_from_session do |user_id|
		# puts '[INFO] serialize from session'
		User.first(:user_id => user_id)
	end
	###

	class FailureApp
		def call(env)
			uri = env['REQUEST_URI']
			puts "failure #{env['REQUEST_METHOD']} #{uri}"
		end
	end
end