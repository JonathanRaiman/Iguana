require './app.rb'
describe 'Wordnet Hierarchy' do

	before(:all) do
		@lawn_chair = App.rdf.find_word("lawn chair").first
		@n = 20
		@chair = Synset.new("chair")
		@furniture = Synset.new("furniture")
		@seat = Synset.new("seat", index: 3)
	end

	it 'should find the topmost element of word' do
		@lawn_chair.topmost_hyponym.should be Synset::Entity
		@lawn_chair.topmost_hyponym(@furniture).should be @seat
	end

	it 'should find the topmost element of hyponym' do
		@chair.topmost_hyponym.should be Synset::Entity
		@chair.topmost_hyponym(@furniture).should be @seat
	end

	it 'should find the children for multiple synsets a once' do
		furniture, bracelet = @furniture, Synset.new("bracelet")
		method1 = Synset.find_children [furniture, bracelet]
		method2 = furniture.find_children + bracelet.find_children
		method1.length.should eq method2.length
		method1.should eq method2
	end

	it 'should find the n topmost elements' do
		Synset::Entity.obtain_children_up_to(@n).length.should be >= @n
	end

	it 'should find the level of a synset from the topmost level' do
		Synset::Entity.level.should be          1
		Synset::PhysicalEntity.level.should be  2
		Synset::Object.level.should be          3
		Synset::Whole.level.should be           4
		Synset::Artifact.level.should be        5
		Synset::Instrumentality.level.should be 6
	end

	it 'should find the elements around a level' do
		object_children = Synset::Object.find_children
		object_parent   = [Synset::Object.find_parent]
		sim_children    = Synset::PhysicalEntity.obtain_similar_children_around_level Synset::Object.level
		Set.new(sim_children).should be_superset Set.new(object_parent+[Synset::Object]+object_children)
	end

	it 'should find the listings for the n topmost categories/hyponyms' do
		search = Synset::Artifact.listings_for_topmost_categories(30)
		search.size.should be 30
		search.listings.should_not be_empty
	end

	it 'should find the listings for a level n' do
		level  = @chair.level
		search = @seat.listings_for_level(level)
		search.level.should be level
		search.listings.should_not be_empty
	end

	it 'should find and store the number of a listings for a similarity class' do
		pillowcase = App.rdf.find_word("pillowcase").first
		count = pillowcase.store_listings_count
	end

end