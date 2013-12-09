#  RDF/Mongo has a troublesome relation with Ruby Symbols,
# we add in strings as cases to better support Mongo conversions and
# transfers between our regular collections and their Linked Data
# counterparts.
class RDF::Mongo::Conversion
	def self.from_mongo(value, value_type = :u, literal_extra = nil)
		case value_type
		when :u, "u"
			RDF::URI.intern(value)
		when :ll, "ll"
			RDF::Literal.new(value, :language => literal_extra.to_sym)
		when :lt, "lt"
			RDF::Literal.new(value, :datatype => RDF::URI.intern(literal_extra))
		when :l, "l"
			RDF::Literal.new(value)
		when :n, "n"
			@nodes ||= {}
			@nodes[value] ||= RDF::Node.new(value)
		when :default, "default"
			nil # The default context returns as nil, although it's queried as false.
		end
	end
end