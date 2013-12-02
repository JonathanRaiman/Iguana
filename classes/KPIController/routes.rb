class App < Sinatra::Base
	
	def self.get_or_post(url,&block)
		get(url,&block)
		post(url,&block)
	end

	get_or_post URLS[:data] do
		handle_data_api
	end

end