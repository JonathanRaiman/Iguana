class App < Sinatra::Base
	register Sinatra::StaticAssets
	set :root, File.dirname(__FILE__)+"/../../"

	module AppStaticAssets
		def all_stylesheets
			[
				(stylesheet_link_tag "/css/style.css", :media => "all"),
				(stylesheet_link_tag "/css/font-awesome.min.css", :media => "all"),
				(stylesheet_link_tag "/css/buttons.css", :media => "all"),
				(stylesheet_link_tag "/css/jquery.jqplot.css", :media => "all"),
				(stylesheet_link_tag "/css/index.css", :media => "all")
			].join("\n")
		end
		def all_javascripts
			[
				(javascript_script_tag "/js/jquery.min.js"),
				(javascript_script_tag "http://twitter.github.com/hogan.js/builds/2.0.0/hogan-2.0.0.js"),
				(javascript_script_tag "/js/bootstrap.min.js"),
				(javascript_script_tag "/js/buttons.js"),
				(javascript_script_tag "/js/highcharts.js"),
				(javascript_script_tag "/js/jquery.jqplot.min.js"),
				(javascript_script_tag "/js/plugins/jqplot.barRenderer.min.js"),
				(javascript_script_tag "/js/plugins/jqplot.categoryAxisRenderer.js"),
				(javascript_script_tag "/js/plugins/jqplot.canvasTextRenderer.js"),
				(javascript_script_tag "/js/plugins/jqplot.canvasAxisLabelRenderer.js"),
				(javascript_script_tag "/js/typeahead.min.js"),
				(javascript_script_tag "/js/Tangle/mootools.js"),
				(javascript_script_tag "/js/Tangle/Tangle.js"),
				(javascript_script_tag "/js/Tangle/TangleKit.js"),
				(javascript_script_tag "/js/Tangle/BVTouchable.js"),
				(javascript_script_tag "/js/index.js")
			].join("\n")
		end
		
	end

	helpers AppStaticAssets
end