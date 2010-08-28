$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'lib/map_reduced'
 
task :build do
  system "gem build map_reduced.gemspec"
end
 
task :release => :build do
  system "gem push map_reduced-#{Bunder::VERSION}"
end