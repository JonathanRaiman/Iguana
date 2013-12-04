module RDF
	class WordsenseSearch < OpenStruct
		def each
			listings.each do |listing|
				yield(listing)
			end
		end
		def to_a
			listings
		end
	end
end