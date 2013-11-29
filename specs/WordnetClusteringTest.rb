require './app.rb'
describe 'Wordnet Clustering' do

	before(:each) do
		@listing = Listing.new(
			:title => "High quality 100% cotton cot bed and pillow case set",
			:tags => ["cot bed","bedding","blue","yellow","homeware","nursery","animal theme","boys"],
			:category_path => %w(Children Baby Bedding)
		)
		@listing.expand_tags
		@shop = Shop.create(
			:shop_id => 007,
			:listings => [@listing]
		)
	end

	it 'should save the expanded_tags of a listing' do
		@shop.reload
		@shop.listings.first.expanded_tags.should == NamedVector.new((@shop.listings.first.tags + @shop.listings.first.category_path)).normalize
	end

	after(:each) do
		Shop.first(:shop_id => 007).destroy
	end

	# it 'should obtain the distance between any two listings' do
		
	# end

	# it 'should create n clusters for all listings' do

	# end

end