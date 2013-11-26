require 'mongo_mapper'
require "etsy"
require 'uri'
class App
	include Mongodb
	setup_database(ENV['MONGOHQ_URL'] ?
		DatabaseConfiguration.from_url(ENV['MONGOHQ_URL']) :
		DatabaseConfiguration.new(:host => "localhost", :port => nil, :database_name => "iguana"))
end

%w(Listing Shop User configuration ShopSearchMethods).map {|d| require_relative(d)}