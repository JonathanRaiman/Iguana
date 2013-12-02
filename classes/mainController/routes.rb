class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end

	post URLS[:old_data] do
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

	get URLS[:autocomplete] do
		handle_autocomplete
	end
end