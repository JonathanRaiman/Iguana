module ShopSearchMethods
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods

		def find_all_listings
			Shop.where().find_each do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
			nil
		end

		def find_all_listing_for_category category
			Shop.where(:"listings.category_path" => category).find_each do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
			nil
		end

		def find_all_users_for_category category
			Shop.where(:"listings.category_path" => category).fields(:user_id).find_each do |shop|
				yield(User.first(:user_id => shop.user_id),shop)
			end
		end
	end

end