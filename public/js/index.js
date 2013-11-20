var active = "jewelery";

//****************************************
//Button functionality to toggle the colors
//****************************************
$(document).ready(function() {
	updateGraphs();
	$(".button-container a").click(function() {
		if ($(this).text() != active) {
			$.each($('.button-container a'),function(index,handle) {
				$(handle).removeClass($(handle).attr('data-class'));
			});
			$(this).addClass($(this).attr('data-class'));
			active = $(this).text().toLowerCase();
			updateGraphs();
		}
	});
});

var updateGraphs = function updateGraphs() {
	$.ajax({
		dataType: "json",
		url: "/data.json",
		data: {'boxes':25,'types':'views,price','category':active},
		success: function(response) {
			var resp = response[active];
			
			var price = resp['price'];
			var price_histogram = price['histograms']['twentyfive_bin'];
			var price_histogram_values = price_histogram['values'];
			var bins = generateBins(price_histogram['bin_width'],25);
			
			var views = resp['views'];
			var views_histogram = views['histograms']['twentyfive_bin'];
			var views_histogram_values = views_histogram['values'];

			$('#graphone').highcharts({
				chart: {type: 'column'},
				title: {text: ''},
				xAxis: {categories: bins,
					title: {
						text: 'Price ($)'
					}
				},
				yAxis: {
					min: 0,
					title: {
						text: 'Quantity'
					}
				},
				tooltip: {
					headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
					pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
						'<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
					footerFormat: '</table>',
					shared: true,
					useHTML: true
				},
				plotOptions: {
					column: {
						pointPadding: 0.2,
						borderWidth: 0
					}
				},
				legend: {
					enabled: false,
				},
				series: [{
					name: '',
					data: price_histogram_values
				}]
			});
			$('#graphthree').highcharts({
				chart: {type: 'column'},
				title: {text: ''},
				xAxis: {categories: bins,
					title: {
						text: 'Number of Views'
					}
				},
				yAxis: {
					min: 0,
					title: {
						text: 'Quantity'
					}
				},
				tooltip: {
					headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
					pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
						'<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
					footerFormat: '</table>',
					shared: true,
					useHTML: true
				},
				plotOptions: {
					column: {
						pointPadding: 0.2,
						borderWidth: 0
					}
				},
				legend: {
					enabled: false,
				},
				series: [{
					name: '',
					data: views_histogram_values
				}]
			});
		}
	});
};


var generateBins = function generateBins(width,number) {
	list = [];
	for (i = 0; i < width*number; i = i+width) {
		list.push(i)
	}
	return list;
};