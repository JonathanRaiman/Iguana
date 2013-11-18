# coding: utf-8
# Load some rubygems:
%w(yaml box_puts json thin omniauth omniauth-etsy).map {|d| require(d)}

# then load some classes:
[
	'../classes/Etsy/Etsy',
	'../classes/etsyParser/EtsyParser',
	'../classes/sinatra',
	'../classes/authController/authController',
	'../classes/authController/warden',
	'../classes/mainController/routes',
	'../classes/tabController/TabController'
].map {|d| require_relative(d)}

class App;include(TabController);end
class App;include(EtsyParser);end