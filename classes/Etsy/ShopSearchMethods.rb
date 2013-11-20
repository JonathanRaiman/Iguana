module ShopSearchMethods
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods
		def find_all_listing_for_category category
			Shop.where(:"listings.category_path" => category).find_each do |shop|
				shop.listings.each do |listing|
					yield(listing,shop)
				end
			end
			nil
		end
	end

end