function (start, end, _args) {

	var collection_name     = _args[0],
		base_uri            = _args[1],
		RDFS_label          = _args[2];

	Array.prototype.remove = function(set){return this.filter(
		function(e,i,a){return set.indexOf(e)<0;}
	);};

	String.prototype.capitalize=function(){
		var words = this.split(" ");
		for (var i=0; i<words.length; i++){
			words[i] = words[i].substring(0,1).toUpperCase()+words[i].substring(1,words[i].length).toLowerCase();
		}
		return words.join(" ");
	};

	String.prototype.superformat = function () {
		return [this.toString(), this.toLowerCase(), this.capitalize()];
	};

	function createURI(base, predicate) {
		return base + "#" + predicate;
	}

	function baseURI(predicate) {
		return base_uri + "#" + predicate;
	}

	function createLD(s, p, o) {
		db.rdf.insert({
			"st" : "u",
			"ot" : "u",
			"ct" : "default",
			"s": s,
			"p": baseURI(p),
			"o": o
		});
	}

	function findWordnetName(name) {
		return db.rdf.findOne({
			"p": RDFS_label,
			"$or": name.superformat().map( function (i) {return {"o": i};})
		});
	}

	function CreateLD (category) {

		var wn_name = findWordnetName(category._id);

		if (wn_name) {

			createLD(wn_name.s, "hasVolume", category.total_inventory_value);

			createLD(wn_name.s, "hasMeanPrice", category.mean_price);

			createLD(wn_name.s, "hasMeanVolume", category.mean_gross);

			createLD(wn_name.s, "hasMeanViews", category.mean_views);

			createLD(wn_name.s, "hasVisibilityProbability", category.visibility_probability);

			createLD(wn_name.s, "hasVisibilityProportion", category.share_of_visibility);

			for (var i=0;i< Math.min(10, category.associated_synsets.length);i++) {
				var synset =category.associated_synsets[i];

				createLD(wn_name.s, "hasAssociatedSynset", synset._id);

			}
		}

	}

	

	var search_opts = {"$gte": start};

	if (end) search_opts["$lte"] = end;

	db[collection_name].find({_id: search_opts, count: {"$gte": 30}}).forEach(CreateLD);
}