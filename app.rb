require_relative('dependencies/requires.rb')
class App;include(TabController);end
App::CONFIG = YAML.load_file(File.expand_path('config/config.yaml', File.dirname(__FILE__)))["config"]
App::SITENAME = App::CONFIG["sitename"]
App.use Rack::Session::Cookie, :expire_after => 31536000, # In seconds
                       :secret => App::CONFIG["session_secret"]

if __FILE__ == $0
	App.run!
else
	BoxPuts.show :title => App::SITENAME, :lines => ["Welcome to #{App::SITENAME}"], :align => "center"
end