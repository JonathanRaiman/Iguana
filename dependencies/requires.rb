# coding: utf-8
# Load some rubygems:
gem 'json', :require => true
%w(yaml box_puts thin omniauth omniauth-etsy jraiman_progressbar rdf rdf/mongo rdf/raptor rdf/rdfa ostruct named_vector parallel mongo_mapper_parallel linkeddata sparql sinatra/sparql equivalent-xml redcarpet).map {|d| require(d)}

# then load some classes:
[
	'../classes/sinatra',
	'../classes/messageController/MessageController',
	'../classes/databaseController/Mongodb',
	'../classes/databaseController/DatabaseConfiguration',
	'../classes/rdf/configuration',
	'../classes/Etsy/Etsy',
	'../classes/etsyParser/EtsyParser',
	'../classes/etsyParser/Clusters',
	'../classes/authController/authController',
	'../classes/authController/warden',
	'../classes/mainController/assets',
	'../classes/mainController/autocomplete',
	'../classes/mainController/routes',
	'../classes/KPIController/dataAPI',
	'../classes/KPIController/routes',
	'../classes/sparqlController/SparqlQuery',
	'../classes/sparqlController/routes'
].map {|d| require_relative(d)}

class App
	include(EtsyAnalytics)
	include(EtsyParser)
	helpers Sinatra::Autocomplete
	helpers Sinatra::DataAPI
	helpers Sinatra::SparqlQuery
	register Sinatra::SPARQL
end
class Shop;include(ShopSearchMethods);end
class Listing
	include(ListingWordnetSearch)
	include(ListingExpansion)
end
QSPARQL = SPARQL