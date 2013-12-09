# coding: utf-8
# Load some rubygems:
gem 'json', :require => true
%w(yaml box_puts thin omniauth omniauth-etsy jraiman_progressbar rdf rdf/mongo rdf/raptor rdf/rdfa ostruct named_vector parallel mongo_mapper_parallel linkeddata sparql sinatra/sparql equivalent-xml redcarpet).map {|d| require(d)}

# then load some classes in order of dependency:
[
	'../classes/sinatra',
	'../classes/messageController/MessageController',
	'../classes/databaseController/Mongodb',
	'../classes/databaseController/DatabaseConfiguration',
	'../classes/rdf/configuration',
	'../classes/Etsy/Etsy',
	'../classes/etsyParser/Histogram',
	'../classes/etsyParser/EtsyParser',
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

# Our app is modular and has several distinct components
# for autocompletion
# querying,
# SPARQL queries,
# and SPARQL endpoints
class App
	include(EtsyParser)
	helpers Sinatra::Autocomplete
	helpers Sinatra::DataAPI
	helpers Sinatra::SparqlQuery
	register Sinatra::SPARQL
end
# Shops are also modular (their search behavior is separated out)
class Shop;include(ShopSearchMethods);end
# Same with listings
class Listing
	include(ListingWordnetSearch)
	include(ListingExpansion)
end
# Namespace confusion is cleared up by creating a duplicate
QSPARQL = SPARQL