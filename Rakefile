require 'rspec/core/rake_task'
desc 'Preprocess LESS files to create CSS'
task :less do
	require 'less'
	Less.paths << File.dirname(__FILE__)+"/less"
	Less.paths << File.dirname(__FILE__)+"/less/bootstrap"
	less = File.open(File.dirname(__FILE__)+"/less/style.less", 'r').read
	parser = Less::Parser.new
	tree = parser.parse less
	css = tree.to_css
	if !File.exists?(File.dirname(__FILE__)+"/public/css/") then Dir.mkdir File.dirname(__FILE__)+"/public/css/" end
	File.open(File.dirname(__FILE__)+"/public/css/style.css", 'w') {|f| f.write(css) }
end

desc 'Import new Etsy seller data (limit, offset)'
task :etsy, :offset, :limit do |t, args|
	require './app'
	App.obtain_etsy_data :limit => args[:limit].to_i, :offset => args[:offset].to_i
end

desc 'Generate categories and counts'
task :categories do
	require './app'
	Category.assemble_categories
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