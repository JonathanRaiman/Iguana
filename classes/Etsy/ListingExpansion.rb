# NamedVector is a seperate library (by yours trully) dedicated to infinite dimensional vector
# multiplication... its fairly extensive, but unfortunately unoptimized for LDV... so not present
# in our final incarnation of Iguana.
module ListingExpansion
	def expand_tags
		@expanded_tags = NamedVector.new((tags + category_path))
		@expanded_tags.normalize
	end

	def dot_product(other)
		@expanded_tags*other.expanded_tags
	end

	alias :* :dot_product
end