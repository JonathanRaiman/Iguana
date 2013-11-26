module RDFSearches
	def similar
		[] unless predicate == RDF::RDFS.label
		wordsense = find_wordsense
		wordsense.first.find_words
	end

	def related_hyponyms
		wordsense = find_wordsense
		children = wordsense.map {|i| i.find_children}.flatten
		parent = wordsense.map {|i| i.find_parent}.flatten
		local  = wordsense.map {|i| i.subject}
		parent + children + local
	end

	def hyponym_similar
		Set.new() unless predicate == RDF::RDFS.label
		words = Set.new
		related_hyponyms.each do |hyponym|
			words.merge(App.rdf.find_wordsense_words(hyponym))
		end
		words
	end

	def find_wordsense
		subject unless predicate != RDF::RDFS.containsWordSense
		App.rdf.find_wordsense subject
	end

	def find_words
		[] unless predicate == RDF::RDFS.containsWordSense
		if @words then @words
		else @words = App.rdf.find_wordsense_words(subject) end
	end

	def find_parent
		[] unless predicate == RDF::RDFS.containsWordSense
		if @parents then @parents
		else @parents = App.rdf.find_parent_hyponyms(subject) end
	end

	def find_children
		[] unless predicate == RDF::RDFS.containsWordSense
		if @children then @children
		else @children = App.rdf.find_children_hyponyms(subject) end
	end

	def each_listing
		Shop.find_each(:"listings.tags" => object.superformat) do |shop|
			shop.each_listing_with_tags(object.superformat) do |listing|
				yield(listing,shop)
			end
		end
	end

	def listings
		found = Set.new
		Shop.find_each(:"listings.tags" => object.superformat) do |shop|
			found.merge(shop.listings_with_tags(object.superformat))
		end
		Shop.find_each(:"listings.category_path" => object.superformat) do |shop|
			found.merge(shop.listings_with_category_paths(object.superformat))
		end
		found
	end

	def listings_similar
		found = Set.new
		similar.each do |word|
			found.merge(word.listings)
		end
		found
	end

	def listings_hyponym
		found = Set.new
		hyponym_similar.each do |word|
			found.merge(word.listings)
		end
		found
	end
end

class RDF::Statement;include(RDFSearches);end
