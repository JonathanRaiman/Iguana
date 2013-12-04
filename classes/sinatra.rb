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
		:auth_failure         => "/auth/failure",
		:data                 => "/data.json",
		:old_data             => "/old_data.json",
		:autocomplete         => "/search.json",
		:sparql               => "/sparql/?",
		:sparql_form          => "/sparql_form/?",
		:ontology             => "/ontology/?"
	}
	before {session[:locale]||= "en"}

	CONFIG = YAML.load_file(File.expand_path('../config/config.yaml', File.dirname(__FILE__)))["config"]
	SITENAME = CONFIG["sitename"]
	use Rack::Session::Cookie, :expire_after => 31536000, :secret => CONFIG["session_secret"]
	use Rack::SPARQL::ContentNegotiation
	use OmniAuth::Builder do
		provider :etsy, CONFIG["etsy"]["key"], CONFIG["etsy"]["secret"], :scope => 'email_r,profile_r,listings_r'
	end

end