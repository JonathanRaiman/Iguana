module RDF
	module Wordnet
		# Wordsense RDF:Statement mashup for more semantic methods (see specs for details)
		module Statement
			def similar
				[] unless predicate == RDF::RDFS.label
				subject.similar
			end

			def superformat
				object.class == RDF::Literal ? object.superformat : []
			end

			def related_hyponyms
				find_wordsense.map {|i| i.related_hyponyms}.flatten
			end

			def hyponym_similar
				Set.new() unless predicate == RDF::RDFS.label
				Synset.hyponym_similar find_wordsense
			end

			def find_wordsense
				subject unless predicate != RDF::WN20.containsWordSense
				App.rdf.find_wordsense(subject) || NilWordsense.new()
			end

			def find_words
				subject.find_words
			end

			def find_parent
				case predicate
				when RDF::WN20.containsWordSense # is a hyponym
					@parent ||= subject.find_parent
				when RDF::RDFS.label # is a 
					wordsense = find_wordsense
					if wordsense then Synset.find_children wordsense
					else nil end
				else
					nil
				end
			end

			def find_children
				case predicate
				when RDF::WN20.containsWordSense # is a hyponym
					@children ||= subject.find_children
				when RDF::RDFS.label # is a 
					wordsense = find_wordsense
					if wordsense then Synset.find_children wordsense
					else [] end
				else
					[]
				end
			end

			def topmost_hyponym(stop_point=[])
				find_wordsense.first.topmost_hyponym(stop_point)
			end
		end
	end
end
