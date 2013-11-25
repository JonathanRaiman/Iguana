require_relative 'Histogram'

module EtsyParser
	SLEEP_TIME = 0.1
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods

		def obtain_etsy_data(opts={})
			shops = opts[:shops] || Etsy::Shop.all(opts)
			current, total = 0, shops.length
			queries_in_last_second = 0
			last_query_time        = 
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