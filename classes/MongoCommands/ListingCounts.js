function (start, end, _args) {
	// for each word in Wordnet obtains the number of listings.

	var rdfs_label = _args[0],
		wn20_word_sense = _args[1],
		ListingCount_collection_name = _args[2];

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

	Array.prototype.overlaps = function (other) {
		if (this.length > other.length) {
			return other.overlaps(this);
		}
		for (var i=0; i< this.length;i++) {
			if (other.indexOf(this[i]) != -1) return true;
		}
		return false;
	};

	function NumberOfListings(words) {
		if (words.length === 0) return 0;

		var count = 0;
		var conditions = [];

		function createConditions (word) {
			return [{"listings.tags": word}, {"listings.category_path": word}];
		}
		// add all OR statements to query to find all stores:
		for (var i=0;i<words.length;i++) {
			var new_conditions = createConditions(words[i]);
			for (var k=0;k<new_conditions.length;k++) {
				conditions.push(new_conditions[k]);
			}
		}

		function updateCount(shop) {
			for (var i=0;i < shop.listings.length; i++) {
				var all_tags = shop.listings[i].tags.concat(shop.listings[i].category_path);
				if (words.overlaps( all_tags )) count++;
			}
		}
		
	
		db.shops.find({
			"$or": conditions
		}).forEach(updateCount);
		return count;

	}

	function findWordNodes(wordsense) {
		return db.rdf.find({
					"s": wordsense,
					"p": wn20_word_sense
				}).toArray().map( function (wordnode) {
					return wordnode["o"];
				});
	}

	function findWordSense(node) {
		var wordsense = db.rdf.find({
			p: wn20_word_sense,
			o: node
		}).toArray().map( function (i) {
			return i.s;
		});
		return wordsense.length > 0 ? wordsense[0] : null;
	}

	function findWordsForWordNodes( nodes) {
		if (nodes.length === 0) return [];
		return db.rdf.find({
					"$or": nodes.map( function (i) {
						return {"s": i};
					}),
					"p": rdfs_label
				}).toArray().map( function (word) {
					return word["o"];
				});
	}

	function SynsetFindWords (wordsense) {
		var nodes = findWordNodes(wordsense);
		return findWordsForWordNodes(nodes);
	}
	function Superformat(words) {
		var new_array = [];
		for (var i=0;i<words.length;i++){
			var new_words = words[i].superformat();
			for (var j=0;j<new_words.length;j++ ) {
				new_array.push(new_words[j]);
			}
		}
		return new_array;
	}

	function SimilarWords (wordnet_word_subject) {
		var wordsense = findWordSense(wordnet_word_subject);
		if (wordsense === null) return [];
		var synset_words = SynsetFindWords(wordsense);
		var flattened_synset = Superformat(synset_words);
		return flattened_synset;
	}

	function SaveListingsCount(wordnet_word) {
		// creates a ListingCount element

		var similar_words = SimilarWords(wordnet_word.s);

		if (db[ListingCount_collection_name].findOne({
			words: similar_words
		}) === null) {

			var count = NumberOfListings(similar_words);

			db[ListingCount_collection_name].insert({
				_id: wordnet_word.s,
				listings_similar_count: count,
				words: similar_words
			});
		}
	}

	var search_opts = {"$gte": start};

	if (end) search_opts["$lte"] = end;

	db.rdf.find({_id: search_opts, p: rdfs_label}).forEach(SaveListingsCount);
}