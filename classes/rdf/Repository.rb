module RDF
	module Mongo
		# The Mongo repository can be extended to support wordsense specific queries we can optimize
		class Repository < ::RDF::Repository
			def find_word word
				query([nil, RDF::RDFS.label, RDF::Literal.new(word, :language => "en-us")]).to_a
			end

			# optimized for multiquery by using OR statement and disregarding non indexed fields
			def find_words words
				words.empty? ? [] : App.rdf_collection.find({
					:"$or" => words.map {|i| {:o => i}},
					:p => RDF::RDFS.label.to_s}).map do |data|
					RDF::Statement.from_mongo(data)
				end
			end

			# optimized for multiquery by using OR statement and disregarding non indexed fields
			def count_words words
				words.empty? ? 0 : App.rdf_collection.find({
					:"$or" => words.map {|i| {:o => i}},
					:p => RDF::RDFS.label.to_s}).count
			end

			def find_word_for_node node
				query([node, RDF::RDFS.label, nil]).to_a.first
			end

			def find_wordsense word_node
				query([nil, RDF::WN20.containsWordSense, word_node]).map {|i| i.subject}
			end

			def find_wordsense_words wordsense_node
				query([wordsense_node, RDF::WN20.containsWordSense, nil]).map do |word_node|
					find_word_for_node word_node.object
				end
			end

			def find_parent_hyponyms wordsense_node
				query([wordsense_node, RDF::WN20.hyponymOf, nil]).map do |hyponym|
					hyponym.object
				end.first
			end

			def find_children_hyponyms wordsense_node
				query([nil, RDF::WN20.hyponymOf, wordsense_node]).map do |hyponym|
					hyponym.subject
				end
			end
		end
	end
end