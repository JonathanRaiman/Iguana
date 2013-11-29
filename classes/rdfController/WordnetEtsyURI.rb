module RDF
	module WordnetEtsy
		module URI
			def listings
				words    = find_words
				listings = Shop.listings_with_words(words.map {|i| i.superformat}.flatten)
				OpenStruct.new hyponym: self, words: words, listings: listings
			end

			def listings_for_topmost_categories size
				hyponyms = obtain_children_up_to size, :levels => true
				search   = {}
				words    = Synset.find_words hyponyms.children
				listings = Shop.listings_with_words(words.map {|i| i.superformat}.flatten)
				search   = WordsenseSearch.new levels: hyponyms.levels, size: size, listings: listings
			end

			def listings_for_level level
				hyponyms = obtain_children_up_to_level level
				search   = {}
				words    = Synset.find_words hyponyms
				listings = Shop.listings_with_words(words.map {|i| i.superformat}.flatten)
				search   = WordsenseSearch.new level: level, listings: listings, search: search
			end
		end
	end
end