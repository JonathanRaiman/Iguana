module Sinatra

	module SparqlQuery

		#  A query is launched by URI decoding the query string and inputting this
		# as a sparql query. SPARQL seems to be only partially implemented in
		# Mongo, since nested queries take a long time to return. Nonetheless
		# for shallow queries this works admirably well given the simplicity of
		# the implementation
		def execute_sparql_query
			query = params["query"].to_s.match(/^http:/) ? RDF::Util::File.open_file(params["query"]) : ::URI.decode(params["query"].to_s)
			@sparql_response = QSPARQL.execute(query, App.rdf)
		end

		#  Available formats
		def sparql_valid_formats
			%w(xml json csv tsv html)
		end

		#  Bad queries store a fail message and return to the form
		def handle_bad_sparql_query
			store_message(t.bad_sparql_query)
			redirect App::URLS[:sparql_form]
		end

		#  Users can specify the format they want the returned triples to be in
		def format_sparql_response
			case params["format"]
			when *sparql_valid_formats
				@sparql_response.send(:"to_#{params['format']}")
			else
				@sparql_response
			end
		end

		#  Service desrciption provides an explanation of the endpoint.
		def return_service_description
			settings.sparql_options.replace(:standard_prefixes => true)
			settings.sparql_options.merge!(:prefixes => {
					:ssd => "http://www.w3.org/ns/sparql-service-description#",
					:void => "http://rdfs.org/ns/void#"
				})
			# doesn't work at this point because 
			service_description(:repo => App.rdf)
		end

		#  Each query can either be malformed or not, and
		#  non-queries return a service description
		def handle_sparql_query
			begin
				if params["query"]
					execute_sparql_query
					format_sparql_response
				else
					return_service_description
				end
			rescue QSPARQL::MalformedQuery
				handle_bad_sparql_query
			end
		end
		# filler text for creating queries
		def default_sparql_query
			"SELECT *
WHERE {
<http://purl.org/vocabularies/princeton/wn30/wordsense-#{%w(bracelet coffee).sample}-noun-1> ?p ?o
}"
		end
	end
	helpers SparqlQuery
end