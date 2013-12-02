function (start, end, _args) {

	Array.prototype.remove = function(set){return this.filter(
		function(e,i,a){return set.indexOf(e)<0;}
	);};

	Array.prototype.overlaps = function (other) {
		if (this.length > other.length) {
			return other.overlaps(this);
		}
		for (var i=0; i< this.length;i++) {
			if (other.indexOf(this[i]) != -1) return true;
		}
		return false;
	};

	// for each word in Wordnet obtains the number of listings.

	var categories_collection_name = _args[0],
		cutoff_for_associated_synsets = _args[1],
		listings_count_collection_name = _args[2];

	// we have to total count of listings for this category
	// total count of stores for this category

	// -mean views
	// -total views

	// and

	// -mean sales
	// -total sales

	// -mean gross
	// -total gross

	function AssociateSynsets (name, totalCount) {

		var synset_counts = [];

		function updateCounts(listing_count) {
			if (listing_count.words.length > 0) {
				var intersection_count = 0;
				db.shops.find({
					"listings.category_path": name
				}).forEach( function (shop) {
					for (var i=0;i<shop.listings.length;i++) {
						if (
							shop.listings[i].category_path.indexOf(name) !== -1 &&
							shop.listings[i].tags.overlaps(listing_count.words)
							)
							intersection_count++;
					}
				});
				if (intersection_count > 0)
					synset_counts.push({
						name: listing_count._id,
						prob: parseFloat(intersection_count) / parseFloat(totalCount)
					});
			}

		}

		db[listings_count_collection_name].find({
			"listings_similar_count": {$gte: cutoff_for_associated_synsets}
		}).forEach(updateCounts);

		synset_counts.sort( function (a, b) {
			return b.prob-a.prob;
		});

		// only keep 100
		synset_counts.slice(100, 999999999999999999);

		return synset_counts;

	}

	function CreateSynsetInformation (category) {
		var associated_synsets = AssociateSynsets(category._id, category.count);
		if (associated_synsets.length > 0) {
			db[categories_collection_name].update({
				_id: category._id
			},
			{
				$push: {
					associated_synsets: {
						$each : AssociateSynsets(category._id, category.count)
					}
				}
			});
		}
	}

	var search_opts = {"$gte": start};

	if (end) search_opts["$lte"] = end;

	db[categories_collection_name].find({_id: search_opts, count: {$gte: cutoff_for_associated_synsets}}).forEach(CreateSynsetInformation);
}