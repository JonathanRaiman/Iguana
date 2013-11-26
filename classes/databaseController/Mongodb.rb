class RDF::Mongo::Repository;attr_accessor :db;end
module Mongodb

	module ClassMethods
		def setup_database db
			MongoMapper.database   = db.database_name
			db.password = 'jimbo'
			db_connection = Mongo::Connection.new(db.host,db.port, :pool_size => 10, :pool_timeout => 30)
			db_connection.db(db.database_name).authenticate(db.user, db.password) if (db and !db.user.nil?)
			MongoMapper.connection = db_connection
			@@RDF = RDF::Mongo::Repository.new(:db => db.database_name,:collection => "rdf")
			@@RDF.db = db_connection
		end

		def rdf
			@@RDF
		end
	end
	def self.included(base); base.extend(ClassMethods);	end
end