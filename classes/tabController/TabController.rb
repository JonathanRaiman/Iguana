module TabController
	def self.included(base); base.extend(ClassMethods);	end

	module ClassMethods
		def sections
			self::CONFIG["tabs"]
			# detail the sections here.
		end
	end
end