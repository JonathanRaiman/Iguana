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