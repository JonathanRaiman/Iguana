desc 'Preprocess LESS files to create CSS'
task :less do
	require './app'
	require 'less'
	Less.paths << "#{App.root}/less"
	Less.paths << "#{App.root}/less/bootstrap"
	less = File.open("#{App.root}/less/style.less", 'r').read
	parser = Less::Parser.new
	tree = parser.parse less
	css = tree.to_css
	if !File.exists?("#{App.root}/public/css/") then Dir.mkdir "#{App.root}/public/css/" end
	File.open("#{App.root}/public/css/style.css", 'w') {|f| f.write(css) }
end

desc 'Import Etsy seller data'
task :etsy do
	require './app'
	App.obtain_etsy_data :limit => 10000
end