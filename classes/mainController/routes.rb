class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end

	post URLS[:data] do
		types = JSON.parse(params[:types])
		hists = App.histogram_for(:category => params[:category], :boxes => params[:boxes] ? params[:boxes].to_i : 10, :types => types)
		resp = {
			category: params[:category],
			series: {}
		}
		types.each do |type|
			resp[:series][type["name"].to_sym] = {
				type: type["name"],
				data: hists[type["name"].to_sym].histogram,
				fork_size: hists[type["name"].to_sym].fork_size,
				min_value: hists[type["name"].to_sym].min_value,
				max_value: hists[type["name"].to_sym].max_value
			}
		end
		resp.to_json
	end

	get '/all_listings' do
		output = ""
		index = 0
		Shop.find_all_listings do |listing|
			output += (listing.price+"\n")
			index +=1 
			if index > 100 then break end
		end
		output
	end
end