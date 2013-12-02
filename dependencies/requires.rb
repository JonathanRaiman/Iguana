# coding: utf-8
# Load some rubygems:
%w(yaml box_puts json thin omniauth omniauth-etsy jraiman_progressbar rdf rdf/mongo rdf/raptor ostruct named_vector parallel mongo_mapper_parallel).map {|d| require(d)}

# then load some classes:
[
	'../classes/sinatra',
	'../classes/databaseController/Mongodb',
	'../classes/databaseController/DatabaseConfiguration',
	'../classes/rdfController/configuration',
	'../classes/Etsy/Etsy',
	'../classes/etsyParser/EtsyParser',
	'../classes/etsyParser/Clusters',
	'../classes/authController/authController',
	'../classes/authController/warden',
	'../classes/mainController/autocomplete',
	'../classes/mainController/routes',
	'../classes/tabController/TabController'
].map {|d| require_relative(d)}

class App;include(EtsyAnalytics);end
class App;include(TabController);end
class App;include(EtsyParser);end
class App;helpers Sinatra::Autocomplete;end
class Shop;include(ShopSearchMethods);end
class Listing;include(ListingWordnetSearch);end
class Listing;include(ListingExpansion);end