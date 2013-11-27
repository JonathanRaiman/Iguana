require './app.rb'
describe 'Wordnet and rdf' do

	before(:all) do
		@word = App.rdf.find_word("jewelry").first
		@chair = App.rdf.find_word("chair").first
	end

	it 'should find a word in the rdf store' do
		@word.object.to_s.should eq "jewelry"
	end

	it 'should find a word sense in the rdf store' do
		senses = App.rdf.find_wordsense @word.subject
		senses.should_not be_empty
	end

	it 'word sense should hold the original word in its similar words' do
		senses = @word.find_wordsense
		sense = senses.first
		sense.find_words.should include @word
	end

	it 'should find other elements in a wordnet synset' do
		similar_words = @word.similar - [@word.object.to_s]
		similar_words.should_not be_empty
		similar_words.should include("jewellery")
	end

	it 'should find a word\' related listings' do
		word = App.rdf.find_word("chair").first
		listings = word.listings
		listings.should_not be_empty
		similar_listings = word.listings_similar
		listings.length.should be <= similar_listings.length
	end

	it 'should find a word\'s hyponyms' do
		word = App.rdf.find_word("chair").first
		word.related_hyponyms.should_not be_empty
		word.related_hyponyms.should include(
			Synset.new("seat", index: 3),
			Synset.new("lawn chair"),
			Synset.new("Eames chair"))
	end

	it 'should find a word\'s hyponymically related words' do
		sim_words =@chair.similar
		words = @chair.hyponym_similar
		sim_words.should_not be_empty
		words.should_not be_empty
		sim_words.length.should be < words.length
	end

	it 'should find a word\'s hyponymically related listings' do
		listings = @chair.listings
		hyponym_listings = @chair.listings_hyponym
		listings.should_not be_empty
		hyponym_listings.should_not be_empty
		listings.length.should be < hyponym_listings.length
	end


end