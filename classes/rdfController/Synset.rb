module Synset
	def self.new(name, opts={})
		pos   = opts[:pos]   || "noun"
		index = opts[:index] || "1"
		RDF::WN30["synset-#{name.gsub(" ", "_")}-#{pos}-#{index}"]
	end

	Entity          = Synset.new "entity"
	PhysicalEntity  = Synset.new "physical entity"
	Object          = Synset.new "object"
	Whole           = Synset.new "whole", index:2
	Artifact        = Synset.new "artifact"
	Instrumentality = Synset.new "instrumentality", index:3

	def self.ethereal
		[Entity,PhysicalEntity,Object,Whole,Artifact,Instrumentality]
	end

	def self.find_word_nodes synsets
		synsets.empty? ? [] : App.rdf_collection.find({
			:"$or" => synsets.map {|i| {:s => i.to_s}},
			:p => RDF::WN20.containsWordSense.to_s}, :fields => {:o => 1}
		).map do |object|
			RDF::URI.new object["o"]
		end
	end

	def self.find_words_for_wordnodes wordnodes
		wordnodes.empty? ? [] : App.rdf_collection.find({
			:"$or" => wordnodes.map {|i| {:s => i.to_s}},
			:p => RDF::RDFS.label.to_s}, :fields => {:o => 1}
		).map do |object|
			object["o"]
		end
	end

	def self.find_words synsets
		nodes = Synset.find_word_nodes synsets
		Synset.find_words_for_wordnodes nodes
	end

	def self.find_children synsets
		synsets.empty? ? [] : App.rdf_collection.find({
			:"$or" => synsets.map {|i| {:o => i.to_s}},
			:p => RDF::WN20.hyponymOf.to_s}, :fields => {:s => 1}
		).map do |object|
			RDF::URI.new object["s"]
		end
	end

	def self.hyponym_similar synsets
		Synset.find_words synsets.map {|i| i.related_hyponyms}.flatten
	end
end