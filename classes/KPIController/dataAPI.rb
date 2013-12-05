module Sinatra
	module DataAPI
		def handle_data_api
			case params[:request_type]
			when "category_stats"
				handle_category_stats
			when "price_stats"
				handle_price_stats
			when "price_view_scatter"
				handle_price_view_scatter
			when "view_stats"
				handle_view_stats
			else
				handle_bad_request
			end
		end

		def find_ListingCount
			@listing_count = Listing::Count.find(params[:_id])
		end

		def handle_category_stats
			if find_ListingCount
				find_correlated_categories_and_return
			else
				handle_bad_request
			end
		end

		def find_correlated_categories_and_return
			categories = @listing_count.correlated_categories_score_only
			categories.to_json
		end

		def return_scatter_plot
			{
				category: params[:_id],
				series: @scatter_plot
			}.to_json
		end

		def return_histograms
			resp = {
			category: params[:_id],
			series: {}
			}
			@types.each do |type|
				resp[:series][type["name"].to_sym] = {
					type: type["name"],
					data: @hists[type["name"].to_sym].histogram,
					mean: @hists[type["name"].to_sym].mean,
					mean_position: @hists[type["name"].to_sym].mean_box,
					fork_size: @hists[type["name"].to_sym].fork_size,
					min_value: @hists[type["name"].to_sym].min_value,
					max_value: @hists[type["name"].to_sym].max_value
				}
			end
			resp.to_json
		end

		def create_histogram_from_types
			@hists = @listing_count.histogram :types => @types, :boxes => params[:boxes] ? params[:boxes].to_i : 10
		end

		def create_scatter_plot_from_types
			@scatter_plot = @listing_count.scatter_plot :types => @types
		end

		def handle_price_view_scatter
			if find_ListingCount
				# x, y
				@types = [create_type_from_request("price"), create_type_from_request("views")]
				create_scatter_plot_from_types
				return_scatter_plot
			else
				handle_bad_request
			end
		end

		def handle_view_stats
			if find_ListingCount
				@types = [create_type_from_request("views")]
				create_histogram_from_types
				return_histograms
			else
				handle_bad_request
			end
		end

		def create_type_from_request name
			type = {"name" => name}
			if !params["#{name}_min_value"].nil? then type.merge!({"min_value" => params["#{name}_min_value"].to_f}) end
			if !params["#{name}_max_value"].nil? then type.merge!({"max_value" => params["#{name}_max_value"].to_f}) end
			type
		end

		def handle_price_stats
			if find_ListingCount
				@types = [create_type_from_request("price")]
				create_histogram_from_types
				return_histograms
			else
				handle_bad_request
			end
		end

		def handle_bad_request
			404
		end
	end
	helpers DataAPI
end