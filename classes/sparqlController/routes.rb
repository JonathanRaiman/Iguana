class App < Sinatra::Base
	get URLS[:sparql] do
		handle_sparql_query
	end

	get URLS[:sparql_form] do
		erb :"rdf/_form"
	end

	get URLS[:ontology] do
		erb :"rdf/_ontology"
	end
end