class App < Sinatra::Base
	get URLS[:sparql] do
		handle_sparql_query
	end

	get URLS[:sparql_form] do
		erb :"rdf/_form"
	end

	route :get, ([URLS[:ontology]] + %w(hasMeanPrice hasVolume hasMeanGross hasMeanViews hasVisibilityProbability hasVisibilityProportion hasAssociatedSynset).map {|i| "/ontology/"+i}) do
		erb :"rdf/_ontology"
	end
end