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

	end

end