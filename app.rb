require_relative('dependencies/requires.rb')
if __FILE__ == $0 then App.run!
else
	BoxPuts.show :title => App::SITENAME, :lines => ["Welcome to #{App::SITENAME}"], :align => "center"
end