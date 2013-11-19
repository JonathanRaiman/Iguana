
class Listing
	include MongoMapper::EmbeddedDocument
	key :listing_id, Integer
	key :state, String
	key :user_id, Integer
	key :category_id, Integer
	key :title, String
	key :description, String
	key :creation_tsz, Float
	key :ending_tsz, Float
	key :last_modified_tsz, Float
	key :price, String
	key :currency_code, String
	key :quantity, Integer
	key :tags, Array
	key :category_path, Array
	key :category_path_ids, Array
	key :materials, Array
	key :url, String
	key :views, Integer
	key :num_favorers, Integer
	key :processing_min, Integer
	key :processing_max, Integer
	key :who_made, String
	key :is_supply, Boolean, :default => false
	key :when_made, String
	# enum(made_to_order, 2010_2013,
	# 2000_2009, 1994_1999, before_1994,
	# 1990_1993, 1980s, 1970s, 1960s,
	# 1950s, 1940s, 1930s, 1920s, 1910s,
	# 1900s, 1800s, 1700s, before_1700)
	key :recipient, String
	# enum(men, women, unisex_adults,
    # teen_boys, teen_girls, teens,
    # boys, girls, children, baby_boys,
    # baby_girls, babies, birds, cats,
    # dogs, pets)
	key :occasion, String
	# enum(anniversary, baptism, 
	# bar_or_bat_mitzvah, birthday,
	# canada_day, chinese_new_year,
	# cinco_de_mayo, confirmation,
	# christmas, day_of_the_dead, easter,
	# eid, engagement, fathers_day, 
	# get_well, graduation, halloween, 
	# hanukkah, housewarming, kwanza, prom,
	# july_4th, mothers_day, new_baby,
	# new_years, quinceanera, retirement,
	# st_patricks_day, sweet_16, sympathy,
	# thanksgiving, valentines, wedding)
	key :style, Array
	key :is_digital, Boolean, :default => false
	key :has_variations, Boolean, :default => false
end

class Etsy::Listing

	attributes :when_made, :processing_min, :processing_max,
	:who_made, :category_path, :category_path_ids, :is_supply,
	:category_id


	def save
		Listing.new(
			:listing_id => id,
			:views => view_count,
			:state => state,
			:currency_code => currency,
			:ending_tsz => ending,
			:last_modified_tsz => modified,
			:creation_tsz => created,
			:title => title,
			:tags => tags,
			:materials => materials,
			:url => url,
			:who_made => who_made,
			:processing_min => processing_min,
			:processing_max => processing_max,
			:num_favorers => num_favorers,
			:category_path => category_path,
			:category_path_ids => category_path_ids,
			:is_supply => is_supply,
			:when_made => when_made,
			:state => state,
			:user_id => user_id,
			:category_id => category_id,
			:price => price,
			:description => description,
			:quantity => quantity
		)
	end

end