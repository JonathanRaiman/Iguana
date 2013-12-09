# Autocomplete routes and functionality is specified here in a true MVC fashion as Jaya would say
require 'sinatra/base'
module Sinatra

	module Autocomplete
		MinSearchLength = 3

		def prepare_search_term
			@search_term = (params[:search] || "").chomp.strip
		end

		def too_short?
			@search_term.length < MinSearchLength
		end

		def return_counts_for_search_term
			t1       = Time.now
			listings = Listing::Count.counts_matching @search_term, :listings_similar_count => {:"$gt" => 0}
			return_results_in_json listings.map {|i| i.to_hash}, Time.now-t1
		end

		def return_results_in_json results, request_time
			{:results => results, :request_time => request_time}.to_json
		end

		def handle_autocomplete
			prepare_search_term
			if too_short?
				return_results_in_json [], 0.0
			else
				return_counts_for_search_term
			end
		end

	end

	helpers Autocomplete

end