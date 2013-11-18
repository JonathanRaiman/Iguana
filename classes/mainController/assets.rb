class App < Sinatra::Base
	SITENAME = "Iguana"
	register Sinatra::StaticAssets
	set :root, File.dirname(__FILE__)+"/../../"
end