class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end

	get URLS[:data] do
		types = params[:types].split(",").map {|i| i.to_sym}
		hists = App.histogram_for(:category => params[:category], :boxes => params[:boxes] ? params[:boxes].to_i : 10, :types => types)
		resp = {
			category: params[:category],
			series: []
		}
		types.each do |type|
			resp[:series] << {
				type: type,
				data: hists[type].histogram,
				fork_size: hists[type].fork_size,
				min_value: hists[type].min_value,
				max_value: hists[type].max_value
			}
		end
		resp.to_json
	end
end