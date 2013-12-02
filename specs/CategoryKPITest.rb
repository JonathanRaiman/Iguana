ENV['RACK_ENV'] = "test"
require './app.rb'
%w(rack rack/test capybara/rspec capybara/dsl).map {|d| require(d)}
Capybara.app = App
RSpec.configure {|conf| conf.include Rack::Test::Methods}
include Capybara::DSL
describe 'Category KPI' do
	def app
		App
	end

	before(:all) do
		@bedroom = Category.find("Bedroom")
		@bed     = Category.find("Bed")
		@listing = Listing::Count.where(:words => "pillowcase").sort(:listings_similar_count.desc).first
	end

	it 'should find correlated categories' do
		correlated_categories = @listing.correlated_categories_only_score
		correlated_categories.should include @bedroom, @bed
	end

	it 'should return correlated categories for Synset', :type => :feature do
		post App::URLS[:data], {
			:request_type => "category_stats",
			:_id => @listing._id}
		last_response.should be_ok
		json_response = JSON.parse(last_response.body)
		json_response.map {|i| i["id"]}.should include @bedroom._id, @bed._id
	end
end