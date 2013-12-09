class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end

	get URLS[:autocomplete] do
		handle_autocomplete
	end
end