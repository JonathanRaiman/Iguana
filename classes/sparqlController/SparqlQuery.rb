module Sinatra

	module SparqlQuery

		def execute_sparql_query
			query = params["query"].to_s.match(/^http:/) ? RDF::Util::File.open_file(params["query"]) : ::URI.decode(params["query"].to_s)
			@sparql_response = QSPARQL.execute(query, App.rdf)
		end

		def sparql_valid_formats
			%w(xml json csv tsv html)
		end

		def format_sparql_response
			case params["format"]
			when *sparql_valid_formats
				@sparql_response.send(:"to_#{params['format']}")
			else
				@sparql_response
			end
		end

		def return_service_description
			settings.sparql_options.replace(:standard_prefixes => true)
			settings.sparql_options.merge!(:prefixes => {
					:ssd => "http://www.w3.org/ns/sparql-service-description#",
					:void => "http://rdfs.org/ns/void#"
				})
			# doesn't work at this point because 
			service_description(:repo => App.rdf)
		end

		def handle_sparql_query
			if params["query"]
				execute_sparql_query
				format_sparql_response
			else
				return_service_description
			end
		end

		def default_sparql_query
			<<-SPARQL
SELECT *
WHERE {
<http://purl.org/vocabularies/princeton/wn30/wordsense-chocolate-noun-1> ?p ?o
}
SPARQL
		end
	end
	helpers SparqlQuery
end