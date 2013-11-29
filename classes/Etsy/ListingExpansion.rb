module ListingExpansion
	def expand_tags
		@expanded_tags = NamedVector.new((tags + category_path))
		@expanded_tags.normalize
	end
end