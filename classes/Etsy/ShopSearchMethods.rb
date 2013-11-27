module ShopSearchMethods
	def self.included(base); base.extend(ClassMethods);	end

	def each_listing_with_tags tags
		listings_with_tags.each do |listing|
			yield(listing)
		end
	end
	
	def each_listing_with_category_paths tags
		listings_with_category_paths.each do |listing|
			yield(listing)
		end
	end

	def listings_with_words words
		listings.reject {|i| ((i.tags + i.category_path) & words).empty?}
	end

	def listings_with_tags tags
		listings.reject {|i| (i.tags & tags).empty?}
	end

	def listings_with_category_paths categories
		listings.reject {|i| (i.category_path & categories).empty?}
	end

	module ClassMethods

		def find_all_listings
			Shop.find_each() do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
		end

		def listings_with_words words
			found = []
			Shop.find_each(:"$or" => [
				{:"listings.tags" => words},
				{:"listings.category_path" => words}
				]) do |shop|
				found += shop.listings_with_words(words)
			end
			found
		end

		def find_all_listing_for_category category
			Shop.find_each(:"listings.category_path" => category) do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
		end

		def find_all_users_for_category category
			Shop.find_each(:"listings.category_path" => category) do |shop|
				yield(User.first(:user_id => shop.user_id),shop)
			end
		end
	end

end