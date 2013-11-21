require 'mongo_mapper'
require "etsy"
require 'uri'

MongoMapper.database   = "iguana"
host = "localhost"
db   = nil
if ENV['MONGOHQ_URL']
	db = URI.parse(ENV['MONGOHQ_URL'])
	host = "#{db.host}:#{db.port}"
end
MongoMapper.connection = Mongo::Connection.new((ENV['MONGOHQ_URL'] || "localhost"),nil, :pool_size => 10, :pool_timeout => 30)
MongoMapper.connection.authenticate(db.user, db.password) if db and !db.user.nil? and !db.password.nil?

%w(Listing Shop User configuration ShopSearchMethods).map {|d| require_relative(d)}