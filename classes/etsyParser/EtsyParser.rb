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
				hists[type] = Histogram.new(:boxes => opts[:boxes])
			end
			Shop.find_all_listing_for_category(opts[:category]) do |listing, shop|
				opts[:types].each do |type|
					hists[type].add listing.send(type).to_f
				end
			end
			hists
		end

	end

end