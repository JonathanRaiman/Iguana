module RDF
	module Wordnet
		module URI
			def similar
				wordsense = App.rdf.find_wordsense(self)
				Synset.find_words wordsense
			end

			def find_parent
				App.rdf.find_parent_hyponyms(self)
			end

			def find_children
				App.rdf.find_children_hyponyms(self)
			end

			def related_hyponyms
				children  = self.find_children
				parent    = self.find_parent
				[parent] + children + [self]
			end

			def hyponym_similar
				Synset.find_words related_hyponyms
			end

			def find_words
				App.rdf.find_wordsense_words(self)
			end

			def topmost_hyponym(*stop_point)
				top_parent = find_parent
				while top_parent
					new_parent = top_parent.find_parent
					if (new_parent and !stop_point.include? new_parent) then top_parent = new_parent
					else break end
				end
				top_parent
			end

			def obtain_children_up_to stop_size, opts={}
				children = find_children
				levels   = 1
				while children.any? and children.length < stop_size
					children = Synset.find_children children
					levels += 1
				end
				if opts[:levels] then OpenStruct.new :levels => levels, :children => children
				else children end
			end

			def obtain_children_up_to_level stop_level
				current_level = level
				children = current_level <= stop_level ? [self] : []
				while current_level <= stop_level and children.length > 0
					children = Synset.find_children children
					current_level += 1
				end
				children
			end

			# +/- of level.
			def obtain_similar_children_around_level stop_level
				current_level = level
				children = current_level <= stop_level+1 ? [self] : []
				kept_levels = []
				while current_level <= stop_level+1 and children.length > 0
					case current_level
					when stop_level-1, stop_level, stop_level+1
						kept_levels += children
					end
					children = Synset.find_children children
					current_level += 1
				end
				kept_levels
			end

			def level
				level, parent = 1, self
				while parent and parent != Synset::Entity
					parent = parent.find_parent
					level += 1
				end
				level
			end
		end
	end
end