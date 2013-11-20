class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end

	get URLS[:data] do
		{
			category: "Jewelry",
			series: [
				{
					type: "price"
					data: [2,4.2, 9.3, 15, 45, 20, 9, 2, 0.5, 0]
				},
				{
					type: "views"
					data: [2,4.2, 9.3, 15, 45, 20, 9, 2, 0.5, 0]
				},
				{
					type: "gross"
					data: [2,4.2, 9.3, 15, 45, 20, 9, 2, 0.5, 0]
				}
			]
		}.to_json
	end
end