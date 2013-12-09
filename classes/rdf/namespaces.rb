# These are the namespaces we use regularly
# Wordnet 2.0
RDF::WN20   = RDF::Vocabulary.new("http://www.w3.org/2006/03/wn/wn20/schema/")
# Wordnet 3.0
RDF::WN30   = RDF::Vocabulary.new("http://purl.org/vocabularies/princeton/wn30/")
# and our very own Iguana
RDF::Iguana = RDF::Vocabulary.new("http://iguanaetsy.herokuapp.com/ontology/")