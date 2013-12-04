class Listing
	class Count
		include MongoMapper::Document
		key :_id, String
		key :listings_similar_count, Integer
		key :words, Array, :default => []

		ensure_index [[:"listings_similar_count", 1]]
		ensure_index [[:"words", 1]], :unique => true

		def to_uri
			RDF::URI.new(_id)
		end

		def similar_words
			to_uri.similar
		end

		# Typeahead formatting hash:
		def to_hash
			{_id: _id, tokens: words, value: _id, count: listings_similar_count}
		end

		def listings_similar
			words = similar_words.map {|i| i.superformat}.flatten
			Shop.listings_with_words words
		end

		# calculates listing counts for each wordnet synset similarity group.
		def self.obtain_counts
			MongoMapperParallel.new(
			:class => MongoMapperStatement,
			:split => :_id,
			:args => [RDF::RDFS.label.to_s, RDF::WN20.containsWordSense.to_s, Listing::Count.collection_name],
			:javascript => File.read(File.dirname(__FILE__)+"/../MongoCommands/ListingCounts.js"))
		end

		def self.counts_matching term, opts={}
			search_opts = {:words => /#{term}/i}
			Listing::Count.where(search_opts.merge(opts)).sort(:listings_similar_count.desc).all
		end

		# find most correlated categories
		def correlated_categories
			Category.where(:"associated_synsets.name" => _id).all
		end

		def correlated_categories_score_only
			cc = correlated_categories
			cc.each do |i|
				i.associated_synsets.reject! do |synset|
					synset.name != _id
				end
			end
			cc
		end
	end
end