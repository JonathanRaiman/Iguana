# coding: utf-8
# Load some rubygems:
['yaml','box_puts','json','thin'].map {|d| require(d)}

# then load some classes:
[
	'../classes/sinatra',
	'../classes/mainController/routes',
	'../classes/tabController/TabController'
].map {|d| require_relative(d)}