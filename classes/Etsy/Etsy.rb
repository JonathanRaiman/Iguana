require 'mongo_mapper'
require "etsy"
require 'uri'
include Mongodb

# setup_database(ENV['MONGOHQ_URL'] ?
# 	DatabaseConfiguration.from_url(ENV['MONGOHQ_URL']) :
# 	DatabaseConfiguration.new(:host => "localhost", :port => nil, :database_name => "iguana"))

setup_database DatabaseConfiguration.from_url("mongodb://heroku:220dee22f49de65f4fe780dd564989ed@paulo.mongohq.com:10051/app19674891")

%w(Listing Shop User configuration ShopSearchMethods).map {|d| require_relative(d)}