module EtsyParser
	# SLEEP TIME is our throttled call behavior
	SLEEP_TIME = 0.1
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods

		# Here we obtain etsy data using the Etsy gem and the EtsyParser class.
		def obtain_etsy_data(opts={})
			shops = opts[:shops] || Etsy::Shop.all(opts)
			current, total = 0, shops.length
			shops.aech do |shop|
				t1 = Time.now
				if shop.user
					shop.user.save
					shop.save
				end
				diff = Time.now-t1
				if diff < EtsyParser::SLEEP_TIME
					sleep (EtsyParser::SLEEP_TIME-diff)
				end
				current += 1
				# Our custom JR Progressbar tells us how we are doing.
				# (by the way this method is
				# called from our Rakefile, so it is easy to call this while the code in our the cloud
				# by running in our Terminal: `heroku run rake etsy[1000,2000]` for 2000 listings, 1000 listings
				# away from the latest ones).
				JRProgressBar.show(current,total)
			end
		end

		def histogram_for(opts={})
			hists = {}
			opts[:types].each do |type|
				hists[type["name"].to_sym] = Histogram.new(:boxes => opts[:boxes])
			end
			Shop.find_all_listing_for_category(opts[:category]) do |listing, shop|
				opts[:types].each do |type|
					val = listing.send(type["name"].to_sym).to_f
					if (!type["min_value"].nil? and val > type["min_value"]) or !type["min_value"]
						if (!type["max_value"].nil? and val < type["max_value"]) or !type["max_value"]
							hists[type["name"].to_sym].add val
						end
					end
				end
			end
			hists
		end

	end

end