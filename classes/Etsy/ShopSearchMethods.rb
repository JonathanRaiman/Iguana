module ShopSearchMethods

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

		def each_listing(opts={})
			Shop.find_each(opts) do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
		end

		def total_listings_and_views
			total = 0
			total_views = 0
			each_listing do |listing|
				total+=1
				total_views += listing.views
			end
			[total, total_views]
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

	def self.included(base); base.extend(ClassMethods);	end

end