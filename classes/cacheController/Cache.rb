# simple Dalli cache proxy methods.
module Sinatra
	module Cache
		def stash key, value
			settings.cache.set key, value
		end

		def retrieve key
			settings.cache.get key
		end

		def fetch key, &block
			settings.cache.fetch key, &block
		end
	end
	helpers Cache
end