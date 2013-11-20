require_relative 'Histogram'

module EtsyParser
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods

		def obtain_etsy_data(opts={})
			shops = opts[:shops] || Etsy::Shop.all(:limit => opts[:limit])
			shops.each do |shop|
				shop.user.save
				shop.save
			end
		end

		def histogram_for(opts={})
			hists = {}
			opts[:types].each do |type|
				hists[type[:name]] = Histogram.new(:boxes => opts[:boxes])
			end
			Shop.find_all_listing_for_category(opts[:category]) do |listing, shop|
				opts[:types].each do |type|
					val = listing.send(type[:name]).to_f
					if (!type[:min_value].nil? and val > type[:min_value]) or !type[:min_value]
						if (!type[:max_value].nil? and val < type[:max_value]) or !type[:max_value]
							hists[type[:name]].add val
						end
					end
				end
			end
			hists
		end

	end

end