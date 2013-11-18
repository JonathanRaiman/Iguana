['sinatra','sinatra/base', 'sinatra/multi_route','sinatra/synchrony','sinatra/r18n','sinatra/static_assets','sinatra/assetpack','less'].map {|d| require(d)}

class App < Sinatra::Base
	register Sinatra::MultiRoute
	register Sinatra::Synchrony
	register Sinatra::R18n
	register Sinatra::StaticAssets
	register Sinatra::AssetPack
	set :root, File.expand_path('../', File.dirname(__FILE__))
	R18n::I18n.default = 'en' # default language
	URLS = {
		:main                 => "/",
		:auth                 => "/auth/:provider/callback",
		:logout               => "/logout",
		:auth_failure         => "/auth/failure"
	}
	before {session[:locale]||= "en"}
end