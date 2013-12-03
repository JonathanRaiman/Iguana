String.prototype.capitalize=function(){
	var words = this.split(" ");
	for (var i=0; i<words.length; i++){
		words[i] = words[i].substring(0,1).toUpperCase()+words[i].substring(1,words[i].length).toLowerCase();
	}
	return words.join(" ");
};

var category = '';
var price = '';
var item = '';


// <Prebaked data>
var categorynames = ['July', 'August','May', 'June', 'July', 'August','May', 'June', 'July', 'August','May', 'June', 'July', 'August','May', 'June', 'July', 'August','May', 'June', 'July', 'August'];
var categoryvalues = [200, 600, 700, 1010,200, 600, 700, 1000, 200, 600, 700, 1000,200, 600, 700, 1000,200, 600, 700, 1010,200, 600, 700, 1000, 200, 600, 700, 1000,200, 600, 700, 1000,200, 600, 700, 1010,200, 600, 700, 1000, 200, 600, 700, 1000,200, 600, 700, 1000];
var pricenames = ['$1-10','$11-20','$21-30','$31-40','$41-50'];
var pricevalues = [200, 600, 700, 1010,200];
// </Prebaked data>

$(document).ready(function() {

var api_url = "/data.json";

function make_api_request(data, cb, cberror) {
	return $.ajax({
		dataType: "json",
		url: api_url,
		type:"POST",
		data: data,
		success: cb,
		error: cberror
	});
}

function get_correlated_categories(item_id, cb, cberror) {
	return make_api_request({
		'request_type':"category_stats",
		'_id': item_id
	}, cb, cberror);
}

function plotCategories (response) {
	response.sort( function (a,b) {
		return b.associated_synsets[0].prob-a.associated_synsets[0].prob;
	});
	response = response.slice(0,10);

	var names  = response.map(function (i) {return i["id"];});
	var values = response.map(function (i) {return i["ratio_of_visibility"];});
	plotdiv(names, values);
}

//****************************************
//** Carousel Functionality **************
//****************************************
function onAutocompleted($e, datum) {
	item = datum._id;
	$('.carousel').carousel(1);
	$("#button2").removeClass("inactive");
	$("#button2").attr("data-target","#myCarousel");
	var req = get_correlated_categories(item, plotCategories, function (response) {plotdiv(categorynames,categoryvalues)});
}

$('.carousel').carousel({
	wrap: false,
	interval: false
});

$(".carousel-control.left").css("display","none");

$('.carousel').on('slid.bs.carousel', function () {
	setTimeout(function(){
		$(".carousel-control.right").css("display","block");
		$(".carousel-control.left").css("display","block");
		if ($(".carousel-indicators .active").attr("data-slide-to") == 3) {
			$(".carousel-control.right").css("display","none");
		} else if ($(".carousel-indicators .active").attr("data-slide-to") == 0){
			$(".carousel-control.left").css("display","none");
		}
	},30);
});
$('.carousel').on('slide.bs.carousel', function () {
	$("#span-item").text(item);
	$("#span-category").text(category);
	$("#span-price").text(price);
});
//****************************************
//** Type Ahead Functionality ************
//****************************************

// Typeahead preferences

(function () {

	function processDuplicateTokens (tokens) {
		var keys = [];
		var found_keys = [];
		for (var i=0;i < tokens.length; i++) {
			var capitalized = tokens[i].capitalize();
			if (!found_keys[capitalized]) {
				keys.push(capitalized);
				found_keys[capitalized] = true;
			}
		}
		return keys;
	}

	function processResponse (response) {
		var processResult = function (result) {
			var processed_tokens = processDuplicateTokens(result.tokens);
			return {count: result.count, tokens:processed_tokens, value: processed_tokens.join(", "), words: processed_tokens.join(", "), _id: result._id};
		};
		return response.results.map(processResult);
	}

	var typeahead_settings = {
		name: 'items',
		template: "<h3>{{words}}</h3><p><span class='badge'>{{count}}</span></p>",
		remote: {
			url:'/search.json?search=%QUERY',
			filter: processResponse
		},
		engine: Hogan
	};

	$('.typeahead').typeahead(typeahead_settings).on('typeahead:selected', onAutocompleted).on('typeahead:autocompleted', onAutocompleted);

	$(document).keypress(function(event) {
		if ( event.keyCode == 13 ) {
			var inputval = $($(".twitter-typeahead span")[0]).text();
			onAutocompleted('a',{'value':inputval});
		}
	});

})();
	
//****************************************
//***** Chart Functionality **************
//****************************************

//*** Plot the chart div *********************

function plotdiv(categorynames,categoryvalues) {

	$.jqplot('chartdiv', [categoryvalues], {
		seriesDefaults:{
			renderer:$.jqplot.BarRenderer,
			rendererOptions: {fillToZero: true, varyBarColor: true,barMargin:2,shadowDepth: 0},
			color: '#52ADED'
		},
		title: 'Best Categories to List Your Item',  
		seriesColors:colorList(categoryvalues,'category'),
		axes: {
			// Use a category axis on the x axis and use our custom ticks.
			xaxis: {
				renderer: $.jqplot.CategoryAxisRenderer,
				ticks: categorynames,
				label:'Category',
			},
			// Pad the y axis just a little so bars can get close to, but
			// not touch, the grid boundaries.  1.2 is the default padding.
			yaxis: {
				pad: 1.05,
				tickOptions: {formatString: '%d'},
				label:'Expected Views',
				labelRenderer: $.jqplot.CanvasAxisLabelRenderer
			}
		},
		grid: {
			drawGridLines: true,        // whether to draw lines across the grid or not.
			gridLineColor: '#cccccc',    // Color of the grid lines.
			background: '#fff',      // CSS color spec for background color of grid.
			borderColor: '#ccc',     // CSS color spec for border around grid.
			borderWidth: 2.0,           // pixel width of border around grid.
			shadow: false,               // draw a shadow for grid.
			renderer: $.jqplot.CanvasGridRenderer,  // renderer to use to draw the grid.
			rendererOptions: {
				barPadding: 0,      // number of pixels between adjacent bars in the same
				barMargin: 0,      // number of pixels between adjacent groups of bars.
				barDirection: 'vertical', // vertical or horizontal.
				barWidth: null,     // width of the bars.  null to calculate automatically.
				shadowOffset: 2,    // offset from the bar edge to stroke the shadow.
				shadowDepth: 5,     // nuber of strokes to make for the shadow.
				shadowAlpha: 0.8,   // transparency of the shadow.
			}      
		},
    });
    //*** Have a hover effect with the cursor and grab a bar click ************
	$('#chartdiv').bind('jqplotDataHighlight',
		function (ev, seriesIndex, pointIndex, data) {
			$(this).css('cursor','pointer');
		}
	);   
	$('#chartdiv').bind('jqplotDataClick',
		function (ev, seriesIndex, pointIndex, data) {
			category = categorynames[pointIndex];
			$('.carousel').carousel(2);
			$("#button3").removeClass("inactive");
			$("#button3").attr("data-target","#myCarousel");
			$.ajax({
				dataType: "json",
				url: "",
				type:"POST",
				data: {'item':item},
				success: function(response) {	
				},
				error: function() {
					pricediv(pricenames,pricevalues);
				}
			});
		}
	);
	$('#chartdiv').bind('jqplotDataUnhighlight',
		function (ev) {
			$(this).css('cursor','default');
		}
	);	 
};

function pricediv(pricenames,pricevalues) {
	$.jqplot('pricediv', [pricevalues], {
        seriesDefaults:{
            renderer:$.jqplot.BarRenderer,
            rendererOptions: {fillToZero: true, varyBarColor: true,barMargin:2,shadowDepth: 0},
            color: '#73C91C'
        },
        title: 'Best Price Ranges to List Your Item',  
        seriesColors:colorList(pricevalues,'price'),
       axes: {
            // Use a category axis on the x axis and use our custom ticks.
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                ticks: pricenames,
                label:'Price',
            },
            // Pad the y axis just a little so bars can get close to, but
            // not touch, the grid boundaries.  1.2 is the default padding.
            yaxis: {
                pad: 1.05,
                tickOptions: {formatString: '%d'},
                label:'Expected Views',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer
            }
        },
        grid: {
			drawGridLines: true,        // whether to draw lines across the grid or not.
			gridLineColor: '#cccccc',    // Color of the grid lines.
			background: '#fff',      // CSS color spec for background color of grid.
			borderColor: '#ccc',     // CSS color spec for border around grid.
			borderWidth: 2.0,           // pixel width of border around grid.
			shadow: false,               // draw a shadow for grid.
			renderer: $.jqplot.CanvasGridRenderer,  // renderer to use to draw the grid.
			rendererOptions: {
				barPadding: 0,      // number of pixels between adjacent bars in the same
				barMargin: 0,      // number of pixels between adjacent groups of bars.
				barDirection: 'vertical', // vertical or horizontal.
				barWidth: null,     // width of the bars.  null to calculate automatically.
				shadowOffset: 2,    // offset from the bar edge to stroke the shadow.
				shadowDepth: 5,     // nuber of strokes to make for the shadow.
				shadowAlpha: 0.8,   // transparency of the shadow.
			}      
		},
    });
    //*** Have a hover effect with the cursor and grab a bar click ************
	$('#pricediv').bind('jqplotDataHighlight',
		function (ev, seriesIndex, pointIndex, data) {
			$(this).css('cursor','pointer');
		}
	);   
	$('#pricediv').bind('jqplotDataClick',
		function (ev, seriesIndex, pointIndex, data) {
			price = pricenames[pointIndex];
			$('.carousel').carousel(3);
			$("#button4").removeClass("inactive");
			$("#button4").attr("data-target","#myCarousel");
		}
	);
	$('#pricediv').bind('jqplotDataUnhighlight',
		function (ev) {
			$(this).css('cursor','default');
		}
	);	 
};
 
}); //end of ready function

//****************************************
//***** Generate colors from list*********
//****************************************
function colorList(list,type) {
	var colors = []
	var maxvalue = Math.max.apply(Math, list);
	$.each(list,function(index,value) {
		if (value == maxvalue) {
			if (type=="category") {
				colors.push("#73C91C");
			} else if (type=="price") {
				colors.push("#B045E6");
			}
		} else {
			colors.push("#ddd");
		}
	});
	return colors
}
//****************************************
//***** Old Update Graph *****************
//****************************************
var updateGraphs = function updateGraphs() {
	$.ajax({
		dataType: "json",
		url: "/data.json",
		type:"POST",
		data: {
			'boxes':15,
			'types':JSON.stringify([
				{name: 'views', min_value: 0, max_value: 200},
				{name: 'price', min_value: 0, max_value: 500}
			]),
			category:active
		},
		success: function(response) {
			var resp = response['series'];
			var price = resp['price'];
			var price_histogram = price['data'];
			var bins = generateBins(price['fork_size'],price_histogram.length);
			
			var views = resp['views'];
			var views_histogram = views['data'];
			var bins = generateBins(views['fork_size'],views_histogram.length);

			
		}
	});
};

//****************************************
//***** Generate Bins Function ***********
//****************************************
var generateBins = function generateBins(width,number) {
	list = [];
	for (i = 0; i < width*number; i = i+width) {
		list.push(parseInt(i))
	}
	return list;
};