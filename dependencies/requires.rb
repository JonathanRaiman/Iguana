# coding: utf-8
# Load some rubygems:
%w(yaml box_puts json thin omniauth omniauth-etsy jraiman_progressbar rdf rdf/mongo rdf/raptor).map {|d| require(d)}

# then load some classes:
[
	'../classes/sinatra',
	'../classes/databaseController/Mongodb',
	'../classes/databaseController/DatabaseConfiguration',
	'../classes/rdfController/namespaces',
	'../classes/rdfController/Repository',
	'../classes/rdfController/Literal',
	'../classes/rdfController/Statement',
	'../classes/Etsy/Etsy',
	'../classes/etsyParser/EtsyParser',
	'../classes/etsyParser/Clusters',
	'../classes/authController/authController',
	'../classes/authController/warden',
	'../classes/mainController/routes',
	'../classes/tabController/TabController'
].map {|d| require_relative(d)}

class App;include(EtsyAnalytics);end
class App;include(TabController);end
class App;include(EtsyParser);end
class Shop;include(ShopSearchMethods);end