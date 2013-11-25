module ShopSearchMethods
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods

		def find_all_listings
			Shop.find_each do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
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