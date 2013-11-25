module Mongodb
	def setup_database db
		MongoMapper.database   = db.database_name
		db_connection = Mongo::Connection.new(db.host,db.port, :pool_size => 10, :pool_timeout => 30)
		db_connection.db(db.database_name).authenticate(db.user, 'jimbo') if (db and !db.user.nil?)
		MongoMapper.connection = db_connection
	end
end