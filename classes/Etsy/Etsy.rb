require 'mongo_mapper'
require "etsy"

MongoMapper.database   = "iguana"
MongoMapper.connection = Mongo::Connection.new("localhost",nil, :pool_size => 10, :pool_timeout => 30)

%w(Listing Shop User configuration).map {|d| require_relative(d)}