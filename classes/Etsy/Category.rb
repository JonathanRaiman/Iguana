class Category
	class AssociatedSynset
		include MongoMapper::EmbeddedDocument
		key :name, String
		key :prob, Float
	end

	include MongoMapper::Document
	AssociatedSynsetCutoff = 30
	key :_id, String
	key :count, Integer, :default => 0
	key :wordnet_words, Boolean, :default => false

	key :views, Integer, :default => 0
	key :mean_views, Float, :default => 0.0

	key :mean_price, Integer, :default => 0
	key :total_inventory_value, Float, :default => 0.0

	key :gross, Float, :default => 0.0
	key :mean_gross, Float, :default => 0.0

	# views per item (prob(View)/item in category)
	key :visibility_probability, Float, :default => 0.0
	# percent of total views
	key :share_of_visibility, Float, :default => 0.0
	# prob(View)/category : prob(AnyView)/AnyCategory
	key :ratio_of_visibility, Float, :default => 0.0

	# the synsets often associated with this category (those that are in use).
	many :associated_synsets, :class => Category::AssociatedSynset

	def self.create_categories
		total_listings, total_views = Shop.total_listings_and_views
		MongoMapperParallel.new(
			:class => Shop,
			:split => :_id,
			:args => [Category.collection_name, RDF::RDFS.label.to_s, total_listings, total_views],
			:javascript => File.read(File.dirname(__FILE__)+"/../MongoCommands/CategoryKPI.js"))
	end

	def self.create_category_synsets
		MongoMapperParallel.new(
			:class => self,
			:split => :_id,
			:maxChunkSizeBytes => 32*1024,
			:args => [Category.collection_name, Category::AssociatedSynsetCutoff, Listing::Count.collection_name],
			:javascript => File.read(File.dirname(__FILE__)+"/../MongoCommands/CategoryKPISynset.js"))
	end

	def self.assemble_categories
		total_listings, total_views = Shop.total_listings_and_views
		pc = MongoMapperParallel.new(
			:class => Shop,
			:split => :_id,
			:args => [Category.collection_name, RDF::RDFS.label.to_s, total_listings, total_views],
			:javascript => File.read(File.dirname(__FILE__)+"/../MongoCommands/CategoryKPI.js"))
		pc.run
		pc = MongoMapperParallel.new(
			:class => self,
			:split => :_id,
			:maxChunkSizeBytes => 32*1024,
			:args => [Category.collection_name, Category::AssociatedSynsetCutoff, Listing::Count.collection_name],
			:javascript => File.read(File.dirname(__FILE__)+"/../MongoCommands/CategoryKPISynset.js"))
		pc.run
		pc
	end

	ensure_index [[:"associated_synsets.name", 1]]

end