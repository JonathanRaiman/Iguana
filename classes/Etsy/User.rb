class User
	include MongoMapper::Document

	key :user_id, Integer   
	key :login_name, String		
	key :email, String
	key :shop_id, Integer
	key :join_tsz, Float
	key :transaction_buy_count, Integer
	key :transaction_sold_count, Integer
	key :country_id, Integer
	key :is_seller, Boolean
	key :gender, String
	key :location, Array # [geo.long, geo.lat] # Float Array for doing $near requests in Mongo.
	# where(:location => {'$near' => location})
	key :image_url, String

	key :oauth_token,                                 String
	key :oauth_token_secret,                          String
	key :authenticated,								  Boolean, :default => false

	# ensure_index [[:location, '2d']]
	ensure_index [[:user_id, 1]], :unique => true

	def self.create_using_auth o
		User.create(
			:user_id => o.info.user_id,
			:login_name => o.info.profile.login_name,
			:email => o.info.email,
			:join_tsz => o.info.profile.join_tsz,
			:transaction_buy_count => o.info.profile.transaction_buy_count,
			:transaction_sold_count => o.info.profile.transaction_sold_count,
			:is_seller => o.info.profile.is_seller,
			:location => o.info.profile.lon ? [o.info.profile.lon, o.info.profile.lat] : nil,
			:image_url => o.info.profile.image_url_75x75,
			:country_id => o.info.profile.country_id,
			:gender => o.info.profile.gender,
			:oauth_token => o.extra.access_token.token,
			:oauth_token_secret => o.extra.access_token.secret,
			:authenticated => true
		)
	end

	# Updates a user profile from the OAuth information
	# @param o [OAuth info hash] the parameters to update the profile from.
	# @return [User] the user as a MongoDB resource.
	def update_using_auth o
		self.user_id                = o.info.user_id
		self.login_name             = o.info.profile.login_name
		self.email                  = o.info.email
		self.join_tsz               = o.info.profile.join_tsz
		self.transaction_buy_count  = o.info.profile.transaction_buy_count
		self.transaction_sold_count = o.info.profile.transaction_sold_count
		self.is_seller              = o.info.profile.is_seller
		self.location               = o.info.profile.lon ? [o.info.profile.lon, o.info.profile.lat] : nil
		self.image_url              = o.info.profile.image_url_75x75
		self.country_id             = o.info.profile.country_id
		self.gender                 = o.info.profile.gender
		self.oauth_token            = o.extra.access_token.token
		self.oauth_token_secret     = o.extra.access_token.secret
		save
		self
	end
end

# Etsy user
class Etsy::User

	# Assigns a shop to an Etsy User
	# @param shop [Etsy::Shop] a shop to assign
	# @return [Etsy::User] the shop owner.
	def assign_shop shop
		@shop_id = shop.id
		self
	end



	# Saves an Etsy::User to a MongoDB collection
	# @return [User] the Etsy user.
	def save
		begin
			user_profile = self.profile
			User.create(
				:user_id => id,
				:login_name => username,
				:email => email,
				:join_tsz => created,
				:transaction_buy_count => user_profile.transaction_buy_count,
				:transaction_sold_count => user_profile.transaction_sold_count,
				:is_seller => user_profile.is_seller,
				:location => user_profile.lon ? [user_profile.lon, user_profile.lat] : nil,
				:image_url => user_profile.image,
				:country_id => user_profile.country_id,
				:gender => user_profile.gender,
				:oauth_token => nil,
				:oauth_token_secret => nil,
				:authenticated => false,
				:shop_id => @shop_id
			)
		rescue NoMethodError
			puts "associated_profile bug"
		end
	end

end