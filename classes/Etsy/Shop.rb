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

end