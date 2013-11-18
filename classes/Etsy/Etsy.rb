require 'mongo_mapper'
MongoMapper.database   = "iguana"
MongoMapper.connection = Mongo::Connection.new("localhost",nil, :pool_size => 10, :pool_timeout => 30)

%w(Shop User Listing).map {|d| require_relative(d)}