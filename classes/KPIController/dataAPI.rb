module Sinatra
	module DataAPI
		def handle_data_api
			case params[:request_type]
			when "category_stats"
				handle_category_stats
			when "price_stats"
				handle_price_stats
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

		def handle_price_stats
			#uh-oh
			handle_bad_request
		end

		def handle_bad_request
			404
		end
	end
	helpers DataAPI
end