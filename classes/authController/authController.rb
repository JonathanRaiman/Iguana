class App < Sinatra::Base
	get App::URLS[:auth_failure] do
		redirect App::URLS[:main]
	end

	get App::URLS[:auth] do
		auth = request.env["omniauth.auth"]
		session[:user_id] = auth.info.user_id # store uid.
		if user = User.first(:user_id => auth.info.user_id)
			user.update_using_auth auth
			env['warden'].set_user(user)
			redirect App::URLS[:main]
		else
			user = User.create_using_auth auth
			env['warden'].set_user(user)
			redirect App::URLS[:main]
		end
	end

	get URLS[:logout] do
		env['warden'].logout
		redirect App::URLS[:main]
	end
end