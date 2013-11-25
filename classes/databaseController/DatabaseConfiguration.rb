require 'ostruct'
class DatabaseConfiguration < OpenStruct
	def self.from_url url
		db = URI.parse(url)
		new(:host => db.host, :user => db.user, :port => db.port, :database_name => db.path.gsub(/^\//, ''))
	end
end