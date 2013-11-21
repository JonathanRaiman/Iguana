var active = "";

//****************************************
//Button functionality to toggle the colors
//****************************************
$(document).ready(function() {
	//updateGraphs();
	$(".button-container a").click(function() {
		if ($(this).text() != active) {
			$.each($('.button-container a'),function(index,handle) {
				$(handle).removeClass($(handle).attr('data-class'));
			});
			$(this).addClass($(this).attr('data-class'));
			active = $(this).text();
			updateGraphs();
		}
	});
});

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
					data: price_histogram
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
					data:views_histogram
				}]
			});
		}
	});
};


var generateBins = function generateBins(width,number) {
	list = [];
	for (i = 0; i < width*number; i = i+width) {
		list.push(parseInt(i))
	}
	return list;
};