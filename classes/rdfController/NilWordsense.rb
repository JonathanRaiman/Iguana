module RDF
	class NilWordSense < RDF::Statement
		def find_children
			[]
		end
		def subject
			RDF::URI.new(nil)
		end
	end
end