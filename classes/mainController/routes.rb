class App < Sinatra::Base
	get URLS[:main] do
		erb :"index/_index"
	end

	post URLS[:data] do
		hists = App.histogram_for(:category => params[:category], :boxes => params[:boxes] ? params[:boxes].to_i : 10, :types => params[:types])
		resp = {
			category: params[:category],
			series: {}
		}
		params[:types].each do |type|
			resp[:series][type[:name].to_sym] = {
				type: type,
				data: hists[type].histogram,
				fork_size: hists[type].fork_size,
				min_value: hists[type].min_value,
				max_value: hists[type].max_value
			}
		end
		resp.to_json
		# {
		# 	categories:["jewelery","children","painting","pets","hats"],

		# 	jewelery: {
		# 		price: {
		# 			listing_size: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		},
		# 		views: {
		# 			view_count: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		}
		# 	},
		# 	children: {
		# 		price: {
		# 			listing_size: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		},
		# 		views: {
		# 			view_count: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		}
		# 	},
		# 	painting: {
		# 		price: {
		# 			listing_size: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		},
		# 		views: {
		# 			view_count: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		}
		# 	},
		# 	pets: {
		# 		price: {
		# 			listing_size: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		},
		# 		views: {
		# 			view_count: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		}
		# 	},
		# 	hats: {
		# 		price: {
		# 			listing_size: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		},
		# 		views: {
		# 			view_count: 100,
		# 			average: 100,
		# 			standard_dev: 100,
		# 			histograms: {
		# 				ten_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10],
		# 					bin_width: 4
		# 				},
		# 				twentyfive_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 					bin_width: 4
		# 				},
		# 				fifty_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4
		# 				},
		# 				onehundred_bin:{
		# 					values: [1,2,3,4,5,6,7,8,9,0],
		# 					bin_width: 4							
		# 				}
		# 			}
		# 		}
		# 	},
		# 	gross_earnings: {
		# 		histograms: {
		# 			ten_bin:{
		# 				values: [1,2,3,4,5,6,7,8,9,10],
		# 				bin_width: 4
		# 			},
		# 			twentyfive_bin:{
		# 				values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
		# 				bin_width: 4
		# 			},
		# 			fifty_bin:{
		# 				values: [1,2,3,4,5,6,7,8,9,0],
		# 				bin_width: 4
		# 			},
		# 			onehundred_bin:{
		# 				values: [1,2,3,4,5,6,7,8,9,0],
		# 				bin_width: 4							
		# 			}
		# 		}
		# 	}
		# }.to_json
	end
end