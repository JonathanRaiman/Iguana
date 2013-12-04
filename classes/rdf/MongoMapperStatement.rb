require 'mongo_mapper'
class MongoMapperStatement
	include MongoMapper::Document
	set_collection_name "rdf" 
	key :s, String # subject
	key :p, String # predicate
	key :o, String # object
	key :ct, String # context

	key :pt, String # ???
	key :st, String # ???
	key :ot, String # ???
end