%w(namespaces NilWordsense Repository Literal WordnetURI WordnetStatement WordnetEtsyStatement WordnetEtsyURI WordnetEtsyListing Statement URI Synset MongoMapperStatement Conversion).map {|d| require_relative(d)}

#  Raptor doesn't have an RDFA writer, we monkey-patch this here.
class RDF::Raptor::RDFa::Format
	writer {RDF::RDFa::Writer}
end