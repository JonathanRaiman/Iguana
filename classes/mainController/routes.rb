require 'sinatra/base'

class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end
end