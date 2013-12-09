# We load our dependencies sequentially here.
require_relative('dependencies/requires.rb')

# App.run! launches the server using Thin at localhost. Heroku uses config.ru to do this.
if __FILE__ == $0 then App.run!
else
	# a message to brighten your day:
	BoxPuts.show :title => App::SITENAME, :lines => ["Welcome to #{App::SITENAME}"], :align => "center"
end