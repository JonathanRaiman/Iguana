require 'mongo_mapper'
require "etsy"
require 'uri'


host = "localhost"
db   = nil
port = nil
database_name = "iguana"
if ENV['MONGOHQ_URL']
	db = URI.parse(ENV['MONGOHQ_URL'])
	host = db.host
	port = db.port
	database_name = db.path.gsub(/^\//, '')
end
MongoMapper.database   = database_name
db_connection = Mongo::Connection.new(host,port, :pool_size => 10, :pool_timeout => 30)
db_connection.db(database_name).authenticate(db.user, 'jimbo') if (db and !db.user.nil?)
MongoMapper.connection = db_connection

%w(Listing Shop User configuration ShopSearchMethods).map {|d| require_relative(d)}