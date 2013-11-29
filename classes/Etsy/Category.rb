class Category
	include MongoMapper::Document
	key :_id, String
	key :count, Integer, :default => 0
	key :wordnet_words, Boolean, :default => false
end