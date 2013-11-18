require_relative('dependencies/requires.rb')
App::CONFIG = YAML.load_file(File.expand_path('config/config.yaml', File.dirname(__FILE__)))["config"]
App::SITENAME = App::CONFIG["sitename"]
App.use Rack::Session::Cookie, :expire_after => 31536000, :secret => App::CONFIG["session_secret"]
App.use OmniAuth::Builder do
	provider :etsy, App::CONFIG["etsy"]["key"], App::CONFIG["etsy"]["secret"], :scope => 'email_r,profile_r,listings_r'
end

if __FILE__ == $0 then App.run!
else
	BoxPuts.show :title => App::SITENAME, :lines => ["Welcome to #{App::SITENAME}"], :align => "center"
end