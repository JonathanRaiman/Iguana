module RDF
	# Crossover between Wordnet RDF::Statement and Etsy listings for targeted hybrid queries
	module WordnetEtsy
		module Statement

			def listings
				Shop.listings_with_words object.superformat
			end

			def listings_count
				listings.count
			end

			def listings_similar
				words = similar.map {|i| i.superformat}.flatten
				Shop.listings_with_words words
			end

			def listings_similar_count
				listings_similar.count
			end

			def store_listings_count
				Listing::Count.create(
					:_id => subject.to_s,
					:listings_similar_count => listings_similar_count
					)
			end

			def listings_hyponym
				words = hyponym_similar.map {|i| i.superformat}.flatten
				Shop.listings_with_words words
			end

			def listings_hyponym_count
				listings_hyponym.count
			end
		end
	end
end