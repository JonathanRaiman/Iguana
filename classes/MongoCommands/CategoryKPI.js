function (start, end, _args) {

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

	function Set (data) {
		this.set = [];
		this.element_keys = {};
		if (data) {
			for (var i=0; i<data.length;i++) {
				this.add(data[i]);
			}
		}
	}

	Set.prototype = {
		add: function (object) {
			if (!this.element_keys[object]) {
				this.set.push(object);
				this.element_keys[object] = true;
			}
		},
		remove: function (set) {
			for (var i=0;i<set.length;i++) {
				delete this.element_keys[set[i]];
			}
			this.set = this.set.remove(set);
		},
		isEmpty: function () {
			return this.set.length === 0;
		},
		clear: function () {
			this.set = [];
			this.element_keys = {};
		},
		toArray: function  () {
			return this.set;
		}
	};

	// for each word in Wordnet obtains the number of listings.

	var categories_collection_name = _args[0],
		RDFS_label = _args[1],
		overall_listings = _args[2],
		overall_views = _args[3];

	// we have to total count of listings for this category
	// total count of stores for this category

	// -mean views
	// -total views

	// and

	// -mean sales
	// -total sales

	// -mean gross
	// -total gross

	function getTotalSales(shop) {
		var user = db.users.findOne({user_id: shop.user_id});
		if (user) {
			return user.transaction_sold_count;
		} else {
			return -1;
		}
	}

	function SumOnProperty(array, property) {
		var sum = 0;
		for (var i=0;i<array.length;i++) {
			sum += array[i][property];
		}
		return sum;
	}

	function WordnetExists(name) {
		var found = db.rdf.findOne({"$or" : name.superformat().map(function (i) {return {"o": i};}), "p" : RDFS_label});
		return found !== null;
	}

	function Exists(name) {
		return db[categories_collection_name].findOne({_id: name}) !== null;
	}

	function ObtainKPI (name) {

		var stores = [];

		function updateStores (shop) {

			var store = {
				total_price: 0.0,
				total_views         : 0,
				numMatchingListings : 0,
				gross               : 0.0,
				totalListings       : 0,
				unique_views        : 0,
				matchingSales       : 0,
				totalSales          : getTotalSales(shop)
			};

			for (var i=0;i<shop.listings.length;i++) {
				var listing = shop.listings[i];
				if (listing.category_path.indexOf(name) !== -1) {
					store.total_price += parseFloat(listing.price);
					store.numMatchingListings += 1;
					store.total_views += listing.views;
					if (listing.views > 0) store.unique_views += 1;
				}
				store.totalListings+= 1;
			}

			if (store.totalSales < 0) store.totalSales = 0;

			var percent_matching_listings = store.numMatchingListings / store.totalListings;

			// iffy logic:
			//
			// *  what is the estimated number of sales in our category?
			//
			// --> percent size of category * total sales
			//
			// *  what is the estimated gross?
			//
			// --> numSales * meanPrice
			//
			store.matchingSales = percent_matching_listings * store.totalSales;
			store.gross = store.matchingSales * (store.total_price / store.numMatchingListings);

			stores.push(store);

		}

		db.shops.find({"listings.category_path": name}).forEach(updateStores);

		// stores now contains all the KPI info we need!
		var total_num_listings = SumOnProperty(stores, "numMatchingListings"),
			total_price        = SumOnProperty(stores, "total_price"),
			total_views        = SumOnProperty(stores, "total_views"),
			unique_views       = SumOnProperty(stores, "unique_views"),
			total_gross        = SumOnProperty(stores, "gross");

		var KPI = {
			_id: name,
			visibility_probability: parseFloat(unique_views)/parseFloat(total_num_listings),
			share_of_visibility: parseFloat(total_views)/parseFloat(overall_views),
			ratio_of_visibility: (parseFloat(total_views)/parseFloat(total_num_listings))/(parseFloat(overall_views)/parseFloat(overall_listings)),
			count: total_num_listings,
			mean_views: (total_num_listings > 0 ? total_views/total_num_listings : 0),
			views: total_views,
			mean_price: (total_num_listings > 0 ? total_price/total_num_listings : 0),
			total_inventory_value: total_price,
			mean_gross: (stores.length > 0 ? total_gross/stores.length : 0),
			gross: total_gross,
			wordnet_words: WordnetExists(name),
			associated_synsets: []
		};

		return KPI;

	}

	function CreateCategory (name) {
		// to create a category we already check if it already exists:
		if (!Exists(name)) {

			var KPI = ObtainKPI(name);

			db[categories_collection_name].insert(KPI);

		}// else { already exists }

	}


	function ExtractCategories(shop) {

		var categories = new Set();
		for (var i=0;i<shop.listings.length;i++) {
			for (var k=0;k<shop.listings[i].category_path.length;k++) {
				categories.add(shop.listings[i].category_path[k]);
			}
		}

		return categories.toArray();
	}

	function CreateCategoryInformation (shop) {
		// for each shop we need to extract the categories
		// for each category we need to obtain the metrics UNLESS they already exist.

		var categories = ExtractCategories(shop);

		for (var k=0;k<categories.length; k++) {
			CreateCategory(categories[k]);
		}

	}

	var search_opts = {"$gte": start};

	if (end) search_opts["$lte"] = end;

	db.shops.find({_id: search_opts}).forEach(CreateCategoryInformation);
}