require 'mongo_mapper'
require "etsy"

MongoMapper.database   = "iguana"
MongoMapper.connection = Mongo::Connection.new((ENV['MONGOHQ_URL'] || "localhost"),nil, :pool_size => 10, :pool_timeout => 30)

%w(Listing Shop User configuration ShopSearchMethods).map {|d| require_relative(d)}