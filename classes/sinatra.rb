['sinatra','sinatra/base', 'sinatra/multi_route','sinatra/synchrony','sinatra/r18n','sinatra/static_assets','sinatra/assetpack','less'].map {|d| require(d)}

# The App is the ruby object responsible for handling our routes, it's an instance of a Sinatra server
class App < Sinatra::Base
	register Sinatra::MultiRoute
	register Sinatra::Synchrony
	register Sinatra::R18n
	register Sinatra::StaticAssets
	register Sinatra::AssetPack
	set :root, File.expand_path('../', File.dirname(__FILE__))
	# English is the default language
	R18n::I18n.default = 'en' # default language
	# These are all the routes (urls) available on our site
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
	# This is the session locale for language choices (site text is defined under i18n for localization)
	before {session[:locale]||= "en"}

	CONFIG = YAML.load_file(File.expand_path('../config/config.yaml', File.dirname(__FILE__)))["config"]
	# Set up the site name for <title> tags:
	SITENAME = CONFIG["sitename"]
	# We keep cookies secret this way:
	use Rack::Session::Cookie, :expire_after => 31536000, :secret => CONFIG["session_secret"]
	use Rack::SPARQL::ContentNegotiation
	# We can authenticate with etsy this way:
	use OmniAuth::Builder do
		provider :etsy, CONFIG["etsy"]["key"], CONFIG["etsy"]["secret"], :scope => 'email_r,profile_r,listings_r'
	end

end