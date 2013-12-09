module RDF
	class Literal
		# Superformat lets us create downcase, upcase, and capitalized versions
		# for better searches
		def superformat
			[to_s, to_s.downcase, to_s.capitalize]
		end
	end
end

class String
	# Superformat lets us create downcase, upcase, and capitalized versions
	# for better searches
	def superformat
		[to_s, to_s.downcase, to_s.capitalize]
	end
end