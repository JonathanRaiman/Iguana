%w(namespaces Repository Literal WordnetURI WordnetStatement WordnetEtsyStatement WordnetEtsyURI WordnetEtsyListing NilWordSense Statement URI Synset MongoMapperStatement Conversion).map {|d| require_relative(d)}

class RDF::Raptor::RDFa::Format
	writer {RDF::RDFa::Writer}
end