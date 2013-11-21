require 'mongo_mapper'
require "etsy"
require 'uri'

MongoMapper.database   = "iguana"
host = "localhost"
db   = nil
port = nil
if ENV['MONGOHQ_URL']
	db = URI.parse(ENV['MONGOHQ_URL'])
	host = db.host
	port = db.port
end
db_connection = Mongo::Connection.new(host,port, :pool_size => 10, :pool_timeout => 30)
db_connection.db("iguana").authenticate(db.user, db.password) if (db and !db.user.nil? and !db.password.nil?)
MongoMapper.connection = db_connection

%w(Listing Shop User configuration ShopSearchMethods).map {|d| require_relative(d)}