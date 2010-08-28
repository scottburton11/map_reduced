# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'lib/map_reduced'
 
Gem::Specification.new do |s|
  s.name        = "map_reduced"
  s.version     = MapReduced::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Scott Burton"]
  s.email       = ["scottburton11@gmail.com"]
  s.homepage    = "http://github.com/scottburton11/map_reduced"
  s.summary     = "Easily add MongoDB mapreduce functions and runners to your Mongo ORM classes"
  s.description = "Easily add MongoDB mapreduce functions and runners to your Mongo ORM classes"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.rdoc)
  s.require_path = 'lib'
end