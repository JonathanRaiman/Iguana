require './app.rb'
describe 'Wordnet Clustering' do

	# what if we were to do k-means clustering, then we would need a similarity function? here it is:

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

	it 'should obtain the distance between any two listings' do
		@listing2 = Listing.new(
			:title => "High quality 100% cotton cot bed and pillow case set",
			:tags => ["cot bed"],
			:category_path => %w(Children Cannibalism)
		)
		@listing2.expand_tags
		(@listing*@listing2).should be_within(0.5).of 0.8
	end

end