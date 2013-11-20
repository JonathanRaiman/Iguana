class Histogram
	attr_reader :boxes
	attr_reader :data
	attr_reader :histogram
	attr_reader :fork_size
	attr_reader :min_value
	attr_reader :max_value

	def initialize(opts={})
		@boxes = opts[:boxes] || 10
		@dirty = false
		@histogram = []
		@fork_size = 0
		@min_value = 0
		@max_value = 0
		@data      = []
	end

	def add value
		@data << value
		@dirty = true
	end

	def rebuild_boxes
		@min_value = @data.min
		@max_value = @data.max
		@fork_size = (@max_value-@min_value)/@boxes

		@histogram = Array.new(@boxes,0)

		@data.each do |data|
			@histogram[[@boxes-1,[0,(data / @fork_size).to_i].max].min] += 1
		end
		@dirty = false
	end

	def histogram
		if @dirty
			rebuild_boxes
			@histogram
		else
			@histogram
		end
	end

	def boxes=(value)
		if @boxes != value
			@boxes = value
			@dirty = true
		end
	end

end