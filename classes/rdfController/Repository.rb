module RDF
	module Mongo
		class Repository < ::RDF::Repository
			def find_word word
				query([nil, RDF::RDFS.label, RDF::Literal.new(word, :language => "en-us")]).to_a
			end

			def find_word_for_node node
				query([node, RDF::RDFS.label, nil]).to_a.first
			end

			def find_wordsense word_node
				query([nil, RDF::WN20.containsWordSense, word_node]).to_a
			end

			def find_wordsense_words wordsense_node
				query([wordsense_node, RDF::WN20.containsWordSense, nil]).map do |word_node|
					find_word_for_node word_node.object
				end
			end

			def find_wordsense_from_hyponym wordsense_node

			end

			def find_parent_hyponyms wordsense_node
				query([wordsense_node, RDF::WN20.hyponymOf, nil]).map do |hyponym|
					hyponym.object
				end
			end

			def find_children_hyponyms wordsense_node
				query([nil, RDF::WN20.hyponymOf, wordsense_node]).map do |hyponym|
					hyponym.subject
				end
			end
		end
	end
end