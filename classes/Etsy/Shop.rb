class Shop
	include MongoMapper::Document
	key :shop_id, Integer
	key :shop_name, String
	key :user_id, Integer
	key :creation_tsz, Float
	key :title, String
	key :announcement,  String
	key :currency_code, String
	key :sale_message, String
	key :digital_sale_message, String
	key :last_updated_tsz, Float
	key :listing_active_count, Integer
	key :login_name, String
	key :num_favorers, Integer
	key :image_url, String
	many :listings,	:class => Listing

	ensure_index [[:shop_id, 1]], :unique => true

end

class Etsy::Shop
	attribute :currency_code
	def user
		Etsy::User.find(user_id)
	end
	def save
		Shop.create(
			:title => title,
			:announcement => announcement,
			:currency_code => currency_code,
			:user_id => user_id,
			:shop_id => id,
			:image_url => image_url,
			:listing_active_count => active_listings_count,
			:creation_tsz => created,
			:shop_name => name,
			:num_favorers => favorers_count,
			:listings => listings.map {|i| i.save}
		)
	end
end