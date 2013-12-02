ENV['RACK_ENV'] = "test"
require './app.rb'
%w(rack rack/test capybara/rspec capybara/dsl).map {|d| require(d)}
Capybara.app = App
RSpec.configure {|conf| conf.include Rack::Test::Methods}
include Capybara::DSL

describe "Iguana's front-end" do
	it 'should show a webpage', :type => :feature  do
		visit App::URLS[:main]
		expect(page).to have_content('Linked Data Ventures')
	end

	# improve specs here for all the javascript we have.
end