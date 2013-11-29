module ListingWordnetSearch
	module ClassMethods
	end

	def all_listing_words
		tags+tags.map {|i| i.downcase}+category_path+category_path.map {|i| i.downcase}
	end

	def find_wordnet_words
		App.rdf.find_words all_listing_words
	end

	def count_wordnet_words
		App.rdf.count_words all_listing_words
	end

	def create_category_tag
		Category.create category_path.map {|c| {:_id => c, :count => 0, :wordnet_words => @wordnet_words}}
		Category.collection.update({
				:"$or" => category_path.map {|c| {:_id => c}}
			}, {
				:"$inc" => {:count => 1}
			}, { multi: true })
		Tag.create tags.map {|t| {:_id => t, :count => 0, :wordnet_words => @wordnet_words}}
		Tag.collection.update({
				:"$or" => tags.map {|t| {:_id => t}}
			}, {
				:"$inc" => {:count => 1}
			}, { multi: true })
	end

	def store_wordnet_status
		count = count_wordnet_words
		if count == 0
			wordnet_words = false
			save
			create_category_tag
		else
			wordnet_words = true
			save
		end
	end

	def self.included(base); base.extend(ClassMethods);	end
end