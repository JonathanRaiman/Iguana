module RDF
	class Literal
		def superformat
			[to_s, to_s.downcase, to_s.capitalize]
		end
	end
end

class String
	def superformat
		[to_s, to_s.downcase, to_s.capitalize]
	end
end