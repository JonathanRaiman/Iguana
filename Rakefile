require 'rspec/core/rake_task'
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
task :etsy, :offset, :limit do |t, args|
	require './app'
	App.obtain_etsy_data :limit => args[:limit].to_i, :offset => args[:offset].to_i
end

desc 'Extract clusters from data'
task :extract_clusters do
	require './app'
	App.extract_clusters
end

desc 'Load new triples'
task :load_triples, :path do |t, args|
	require './app'
	App.rdf.load(args[:path])
end

RSpec::Core::RakeTask.new(:test) do |t|
	t.pattern = 'specs/*.rb'
	t.rspec_opts = '--color --format s'
end