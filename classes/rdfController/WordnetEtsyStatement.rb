module RDF
	module WordnetEtsy
		module Statement

			def listings
				Shop.listings_with_words object.superformat
			end

			def listings_similar
				words = similar.map {|i| i.superformat}.flatten
				Shop.listings_with_words words
			end

			def listings_hyponym
				words = hyponym_similar.map {|i| i.superformat}.flatten
				Shop.listings_with_words words
			end
		end
	end
end