String.prototype.capitalize=function(){
	var words = this.split(" ");
	for (var i=0; i<words.length; i++){
		words[i] = words[i].substring(0,1).toUpperCase()+words[i].substring(1,words[i].length).toLowerCase();
	}
	return words.join(" ");
};

$(document).ready(function() {

	var price                     = "$0 - $0",
		mean_price                = 0.0,
		item                      = {},
		itemval                   = '',
		api_url                   = "/data.json",
		carousel_id               = "#myCarousel",
		pricing_title             = "Best price to list your item",
		pricing_xlabel            = "Price ranges",
		pricing_ylabel            = "Occurence",
		pricing_scatter_xlabel    = "Price",
		pricing_scatter_ylabel    = "Views",
		pricing_format            = "%d",
		category_xlabel           = "Associated Categories",
		category_ylabel           = "Visibility",
		category_title            = "Best categories to list your items",
		category_format           = "%.0f %",
		price_regex               = /^\$([^-]+) - \$([^-]+)/,
		price_format              = Hogan.compile("${{min_value}} - ${{max_value}}"),
		histogram_default_boxes   = 50,
		pricing_min_value_default = 0,
		pricing_max_value_default = 150,
		carousel                  = $(carousel_id),
		carousel_indicators       = carousel.find(".carousel-indicators"),
		plots                     = [],
		max_color                 = "#91ef92",
		default_color             = "#e8989a",
		max_categories_shown      = 10,
		activated_buttons         = 0,
		tangle;

	Tangle.formats.preciseDollars = function (value) {
		return "$" + value.toFixed(2);
	};

	var isAnyAdjustableNumberDragging = false;

	Tangle.classes.TKAdjustableSelect = {

	    initialize: function (element, options, tangle, variable) {
	        this.element = element;
	        this.tangle = tangle;
	        this.variable = variable;

			this.position       = (options.position !== undefined) ? parseInt(options.position)  : 0;
			
			this.choices        = (options.choices  !== undefined) ? JSON.parse(options.choices) : [];
			this.step           = (options.step     !== undefined) ? parseInt(options.step)      : 1;
			this.choices_length = (options.choices  !== undefined) ? this.choices.length         : 1;
	        
	        this.initializeHover();
	        this.initializeHelp();
	        this.initializeDrag();

	        var tangle_model = this;

	        this.element.setChoices = function (new_choices, index) {
	        	tangle_model.choices = new_choices;
	        	tangle_model.choices_length = new_choices.length;
	        	tangle_model.position = index !== undefined ? index : 0;
	        	tangle_model.tangle.setValue(tangle_model.variable, new_choices[tangle_model.position]);
	        }
	    },


	    // hover
	    
	    initializeHover: function () {
	        this.isHovering = false;
	        this.element.addEvent("mouseenter", (function () { this.isHovering = true;  this.updateRolloverEffects(); }).bind(this));
	        this.element.addEvent("mouseleave", (function () { this.isHovering = false; this.updateRolloverEffects(); }).bind(this));
	    },
	    
	    updateRolloverEffects: function () {
	        this.updateStyle();
	        this.updateCursor();
	        this.updateHelp();
	    },
	    
	    isActive: function () {
	        return this.isDragging || (this.isHovering && !isAnyAdjustableNumberDragging);
	    },

	    updateStyle: function () {
	        if (this.isDragging) { this.element.addClass("TKAdjustableNumberDown"); }
	        else { this.element.removeClass("TKAdjustableNumberDown"); }
	        
	        if (!this.isDragging && this.isActive()) { this.element.addClass("TKAdjustableNumberHover"); }
	        else { this.element.removeClass("TKAdjustableNumberHover"); }
	    },

	    updateCursor: function () {
	        var body = document.getElement("body");
	        if (this.isActive()) { body.addClass("TKCursorDragHorizontal"); }
	        else { body.removeClass("TKCursorDragHorizontal"); }
	    },


	    // help

	    initializeHelp: function () {
	        this.helpElement = (new Element("div", { "class": "TKAdjustableNumberHelp" })).inject(this.element, "top");
	        this.helpElement.setStyle("display", "none");
	        this.helpElement.set("text", "drag");
	    },
	    
	    updateHelp: function () {
	        var size = this.element.getSize();
	        var top = -size.y + 7;
	        var left = Math.round(0.5 * (size.x - 20));
	        var display = (this.isHovering && !isAnyAdjustableNumberDragging) ? "block" : "none";
	        this.helpElement.setStyles({ left:left, top:top, display:display });
	    },


	    // drag
	    
	    initializeDrag: function () {
	        this.isDragging = false;
	        new BVTouchable(this.element, this);
	    },
	    
	    touchDidGoDown: function (touches) {
	        this.positionAtMouseDown = this.choices.indexOf(this.tangle.getValue(this.variable));
	        this.isDragging = true;
	        isAnyAdjustableNumberDragging = true;
	        this.updateRolloverEffects();
	        this.updateStyle();
	    },
	    
	    touchDidMove: function (touches) {
	        var value = this.positionAtMouseDown + touches.translation.x / 5 * this.step;
	        value = ((value / this.step).round() * this.step) % this.choices_length;
	        value = value < 0 ? value + this.choices_length : value;
	        this.tangle.setValue(this.variable, this.choices[value]);
	        this.updateHelp();
	    },
	    
	    touchDidGoUp: function (touches) {
	        this.isDragging = false;
	        isAnyAdjustableNumberDragging = false;
	        this.updateRolloverEffects();
	        this.updateStyle();
	        this.helpElement.setStyle("display", touches.wasTap ? "block" : "none");
	    }
	};

	tangle = new Tangle($(".summary_page")[0], {
			initialize: function () {
				this.price = 0.0;
				this.item = "item";
				this.category = "category";
				this.visibility = 1;
				this.above_average_price = 0.0;
			},
			update: function () {
				// inexact science:
				this.above_average_price = this.price - mean_price;
				this.visibility = Math.max(1,(600*Math.pow(2.7182818285, -(Math.abs(mean_price-this.price)/15)*0.3)).toFixed(2));
			}
	});

	function slide_to_carousel (num) {
		carousel.carousel(num-1);
	}

	function activate_carousel_buttons (num) {
		var button = $(carousel_indicators.children("li")[num-1]);
		button.removeClass("inactive");
		button.attr("data-target",carousel_id);
		activated_buttons = Math.max(activated_buttons, num-1);
	}

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

	function get_price_view_scatter_plot(item_id, cb, cberror) {
		// returns a 2D array with price and view as dimensions.
		return make_api_request({
			'request_type': 'price_view_scatter',
			'_id': item_id,
			'price_min_value': pricing_min_value_default,
			'price_max_value': pricing_max_value_default
		}, cb, cberror);
	}

	function get_correlated_categories(item_id, cb, cberror) {
		return make_api_request({
			'request_type':"category_stats",
			'_id': item_id
		}, cb, cberror);
	}

	function get_pricing_information(item_id, cb, cberror) {
		return make_api_request({
			'request_type':"price_stats",
			'_id': item_id,
			'boxes': histogram_default_boxes,
			'price_min_value': pricing_min_value_default,
			'price_max_value': pricing_max_value_default
		}, cb, cberror);
	}

	function get_views_information(item_id, cb, cberror) {
		return make_api_request({
			'request_type':"view_stats",
			'_id': item_id,
			'boxes': histogram_default_boxes
		}, cb, cberror);
	}

	function plotCategories (response) {
		response.sort( function (a,b) {
			return b.associated_synsets[0].prob*b.count-a.associated_synsets[0].prob*b.count;
		});
		response = response.slice(0,max_categories_shown);
		var bin_labels = response.map(function (i) {return i["id"];});
		var values = response.map(function (i) {return i["ratio_of_visibility"]*100;});
		createPlot("chartdiv", {
			title: category_title,
			xlabel: category_xlabel+" for <span class='selected-synset'>"+item.words+"</span>",
			ylabel: category_ylabel,
			yaxisFormat: category_format,
			values: values,
			labels: bin_labels
		}, saveClickedCategory);
	}


	//****************************************
	//***** Generate Bins Function ***********
	//****************************************

	function generateBins (width,number) {
		list = [];
		for (i = 0; i < width*number; i = i+width) {
			list.push(price_format.render({"min_value": i.toFixed(2), "max_value": (i+width).toFixed(2)}));

			// list.push("$"+i.toFixed(2)+" - $"+(i+width).toFixed(2));
		}
		return list;
	}

	function showPriceOnHover (event, seriesIndex, pointIndex, data) {
		var plot = $("#"+getPlotIDfromEvent(event));
		var ticks = plot.find(".jqplot-xaxis .jqplot-xaxis-tick");
		var tick = $(ticks[pointIndex]);
		ticks.removeClass("jqplot-xaxis-tick-hovered");
		tick.addClass("jqplot-xaxis-tick-hovered");
	}
	function hidePriceOnExit (event) {
		var plot = $("#"+getPlotIDfromEvent(event));
		var ticks = plot.find(".jqplot-xaxis .jqplot-xaxis-tick");
		ticks.removeClass("jqplot-xaxis-tick-hovered");
	}

	function plotPricingScatter (response) {
		var scatter = response['series'];
		createPlot("pricediv", {
			scatter: true,
			title: pricing_title,
			hiddenTicks: false,
			xlabel: pricing_scatter_xlabel,
			ylabel: pricing_scatter_ylabel,
			yaxisFormat: pricing_format,
			xaxisFormat: '$%.0f',
			values: response['series']
		}, saveClickedScatterPrice);
	}

	function plotPricing (response) {
		var price = response['series']['price'];
		var bin_labels = generateBins(price['fork_size'],price["data"].length);
		mean_price = price['mean'];
		createPlot("pricediv", {
			highlight_bin: price['mean_position'],
			title: pricing_title,
			hiddenTicks: true,
			xlabel: pricing_xlabel,
			ylabel: pricing_ylabel,
			yaxisFormat: pricing_format,
			values: price["data"],
			labels: bin_labels
		}, saveClickedPrice, showPriceOnHover, hidePriceOnExit);
	}

	function pickedTokenFromTokens (tokens, tester) {
		var regexp = new RegExp(tester, "i");
		for (var i=0;i<tokens.length;i++) {
			if (regexp.test(tokens[i]))
				return tokens[i];
		}
		return tokens[0];
	}

	//****************************************
	//** Carousel Functionality **************
	//****************************************
	function onAutocompleted($e, datum) {
		item    = datum;
		itemval = pickedTokenFromTokens(datum.tokens, $e.target.value);
		slide_to_carousel(2);
		activate_carousel_buttons(2);
		get_correlated_categories(item._id, plotCategories, displayDefaultCategories);
	}

	function newMidPrice(price_range) {
		var matches = price_regex.exec(price_range);
		return (parseFloat(matches[1])+parseFloat(matches[2]))/2.0;
	}

	function updateCategoryDecision(categories, index) {
		$("#span-category")[0].setChoices(categories, index);
	}

	function updateFinalSlideInfo () {
		tangle.setValue("price",newMidPrice(price));
		$("#span-item")[0].setChoices(item.tokens);
		tangle.setValue("item", itemval);
	}

	carousel.carousel({
		wrap: false,
		interval: false
	});

	function left_carousel_controls_visibily (show) {
		if (show) {
			carousel.find(".carousel-control.left").css("display","block");
		} else {
			carousel.find(".carousel-control.left").css("display","none");
		}
	}

	function right_carousel_controls_visibily (show) {
		if (show) {
			carousel.find(".carousel-control.right").css("display","block");
		} else {
			carousel.find(".carousel-control.right").css("display","none");
		}
	}

	left_carousel_controls_visibily(false);
	right_carousel_controls_visibily(false);

	function activeSlideNumber () {
		return $(".carousel-indicators .active").attr("data-slide-to");
	}

	carousel.on('slid.bs.carousel', function () {
		setTimeout(function(){
			var active_slide_number = activeSlideNumber();
			right_carousel_controls_visibily(false);
			left_carousel_controls_visibily(false);
			if (active_slide_number < activated_buttons) {
				right_carousel_controls_visibily(true);
			} else if (active_slide_number > 0){
				left_carousel_controls_visibily(true);
			}
		},30);
		updateFinalSlideInfo();
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
				return {count: result.count, tokens:processed_tokens, value: pickedTokenFromTokens(processed_tokens, $(".typeahead").val()), words: processed_tokens.join(", "), _id: result._id};
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

		$('.typeahead').focus();

	})();

	//****************************************
	//***** Generate colors from list*********
	//****************************************
	function colorList(list, preferredPosition) {
		var stop_index = preferredPosition !== undefined ? preferredPosition : list.indexOf(Math.max.apply(Math, list)),
			colors = [];
		for (var i=0; i < list.length;i++) {
			if (i=== stop_index) {
				colors.push(max_color);
			} else {
				colors.push(default_color);
			}
		}
		return colors;
	}
		
	//****************************************
	//***** Chart Functionality **************
	//****************************************

	function createPlot(id, _args, click_cb, hover_cb, unhover_cb) {
		var plot = $("#"+id);
		if (plots[id]) plots[id].destroy();
		plots[id] = $.jqplot(id, [_args["values"]], {
			seriesDefaults:{
				renderer:$.jqplot.BarRenderer,
				rendererOptions: {fillToZero: true, varyBarColor: true,barMargin:2,shadowDepth: 0},
				color: default_color
			},
			title: _args["title"],
			seriesColors: _args["highlight_bin"] !== undefined ? colorList(_args["values"],_args["highlight_bin"]) : colorList(_args["values"]),
			axes: {
				// Use a category axis on the x axis and use our custom ticks.
				xaxis: {
					min: 0,
					renderer: $.jqplot.CategoryAxisRenderer,
					ticks: _args["labels"],
					label:_args["xlabel"],
					tickOptions: _args["xaxisFormat"] ? {formatString: _args["xaxisFormat"] || '%d'} : {},
				},
				// Pad the y axis just a little so bars can get close to, but
				// not touch, the grid boundaries.  1.2 is the default padding.
				yaxis: {
					pad: 1.05,
					min: 0,
					tickOptions: {formatString: _args["yaxisFormat"] || '%d'},
					label:_args["ylabel"],
					labelRenderer: $.jqplot.CanvasAxisLabelRenderer
				}
			},
			grid: {
				drawGridLines: true,        // whether to draw lines across the grid or not.
				gridLineColor: '#cccccc',    // Color of the grid lines.
				background: 'transparent',      // CSS color spec for background color of grid.
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
			}
		});
		//*** Have a hover effect with the cursor and grab a bar click ************

		plot.bind('jqplotDataHighlight',
			function (ev, seriesIndex, pointIndex, data) {
				$(this).css('cursor','pointer');
				if (hover_cb)
					hover_cb(ev, seriesIndex, pointIndex, data);
			}
		);
		if (click_cb)
			plot.bind('jqplotDataClick', click_cb);
		plot.bind('jqplotDataUnhighlight',
			function (ev, seriesIndex, pointIndex, data) {
				$(this).css('cursor','default');
				if (unhover_cb)
					unhover_cb(ev, seriesIndex, pointIndex, data);
			}
		);
		var max_index = _args["highlight_bin"] !== undefined ? _args["highlight_bin"] : _args["values"].indexOf(Math.max.apply(Math,_args["values"]));
		var ticks = plot.find(".jqplot-xaxis .jqplot-xaxis-tick");
		if (_args["hiddenTicks"])
			ticks.addClass("jqplot-xaxis-tick-hidden");
		var max_tick = $(ticks[max_index]);
		max_tick.addClass("jqplot-xaxis-tick-max");
		plot.find(".jqplot-xaxis-label").css("position", "relative");

	}

	function createPlot(id, _args, click_cb, hover_cb, unhover_cb) {
		var plot = $("#"+id);
		if (plots[id]) plots[id].destroy();
		plots[id] = $.jqplot(id, [_args["values"]], {
			seriesDefaults: _args.scatter ? {} : {
				renderer:$.jqplot.BarRenderer,
				rendererOptions: {fillToZero: true, varyBarColor: true,barMargin:2,shadowDepth: 0},
				color: '#73C91C'
			},
			series: _args.scatter ? [{showLine: false, markerOptions: {size: 4, style: "circle"}}] : [],
			title: _args["title"],
			seriesColors: _args.scatter ? undefined : (_args["highlight_bin"] !== undefined ? colorList(_args["values"],_args["highlight_bin"]) : colorList(_args["values"])),
			axes: {
				// Use a category axis on the x axis and use our custom ticks.
				xaxis: {
					renderer: _args.scatter ? undefined : $.jqplot.CategoryAxisRenderer,
					ticks: _args.scatter ? undefined : _args["labels"],
					label: _args["xlabel"],
				},
				// Pad the y axis just a little so bars can get close to, but
				// not touch, the grid boundaries.  1.2 is the default padding.
				yaxis: {
					pad: 1.05,
					min: 0,
					tickOptions: {formatString: _args["yaxisFormat"] || '%d'},
					label:_args["ylabel"],
					labelRenderer: $.jqplot.CanvasAxisLabelRenderer
				}
			},
			grid: {
				drawGridLines: true,        // whether to draw lines across the grid or not.
				gridLineColor: '#cccccc',    // Color of the grid lines.
				background: 'transparent',      // CSS color spec for background color of grid.
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
			}
		});
		//*** Have a hover effect with the cursor and grab a bar click ************

		plot.bind('jqplotDataHighlight',
			function (ev, seriesIndex, pointIndex, data) {
				$(this).css('cursor','pointer');
				if (hover_cb)
					hover_cb(ev, seriesIndex, pointIndex, data);
			}
		);
		if (click_cb)
			plot.bind('jqplotDataClick', click_cb);
		plot.bind('jqplotDataUnhighlight',
			function (ev, seriesIndex, pointIndex, data) {
				$(this).css('cursor','default');
				if (unhover_cb)
					unhover_cb(ev, seriesIndex, pointIndex, data);
			}
		);
		var max_index = _args["highlight_bin"] !== undefined ? _args["highlight_bin"] : _args["values"].indexOf(Math.max.apply(Math,_args["values"]));
		var ticks = plot.find(".jqplot-xaxis .jqplot-xaxis-tick");
		if (_args["hiddenTicks"])
			ticks.addClass("jqplot-xaxis-tick-hidden");
		var max_tick = $(ticks[max_index]);
		max_tick.addClass("jqplot-xaxis-tick-max");
		plot.find(".jqplot-xaxis-label").css("position", "relative");

	}
	//****************************************
	//***** Histogram Callbacks **************
	//****************************************

	function displayDefaultPricing () {
		var pricenames = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45'],
			pricevalues = [30, 20, 50, 60, 150,190, 50, 10,220,30,50, 40, 20, 80,140,90, 20, 50, 200, 19,36, 50, 10,50,40,20, 90, 70, 10,140,30, 20, 50, 60, 40,26, 50, 10,10,20,20, 6, 7,4,3];
		createPlot("pricediv", {
			title: pricing_title,
			hiddenTicks: true,
			xlabel: pricing_xlabel,
			ylabel: pricing_ylabel,
			yaxisFormat: pricing_format,
			values: pricevalues,
			labels: pricenames
		}, saveClickedPrice);
	}

	function getPlotIDfromEvent (event) {
		return event.currentTarget.id;
	}
	function getPlotFromClick (event) {
		return plots[getPlotIDfromEvent(event)];
	}

	function getLabelsFromPlot( plot) {
		return plot.axes.xaxis.ticks;
	}

	function displayDefaultCategories () {
		var categorynames = ['Handmade', 'Vintage','Craft', 'Stone Jewelry', 'Bracelets','Birthstones', 'iPhone Jewelry', 'Belly Button Jewelry','Luxury'],
			categoryvalues = [200, 600, 700, 1010,200, 600, 700, 1000, 200];
		createPlot("pricediv", {
			title: category_title,
			xlabel: category_xlabel,
			ylabel: category_ylabel,
			yaxisFormat: category_format,
			values: pricevalues,
			labels: pricenames
		}, saveClickedPrice);
	}


	function saveClickedCategory (ev, seriesIndex, pointIndex, data) {
		// store category
		var labels = getLabelsFromPlot(getPlotFromClick(ev));

		updateCategoryDecision(labels, pointIndex);
		// slide to next carousel
		slide_to_carousel(3);
		activate_carousel_buttons(3);
		// get_price_view_scatter_plot(item._id, plotPricingScatter, displayDefaultPricing);
		get_pricing_information(item._id, plotPricing, displayDefaultPricing);
	}

	function saveClickedScatterPrice (ev, seriesIndex, pointIndex, data) {
		price = price_format.render({"min_value": data[0], "max_value": data[0]});
		slide_to_carousel(4);
		activate_carousel_buttons(4);
	}

	function saveClickedPrice (ev, seriesIndex, pointIndex, data) {
		var labels = getLabelsFromPlot(getPlotFromClick(ev));
		price = labels[pointIndex];
		slide_to_carousel(4);
		activate_carousel_buttons(4);
	}
 
});
