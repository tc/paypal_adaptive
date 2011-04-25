require 'rubygems'
require 'psych'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "paypal_adaptive"
    gem.summary = %Q{initial import}
    gem.description = %Q{Lightweight wrapper for Paypal's Adaptive Payments API.}
    gem.email = "tommy.chheng@gmail.com"
    gem.homepage = "http://github.com/tc/paypal_adaptive"
    gem.authors = ["Tommy Chheng"]
    gem.add_development_dependency "json", ">= 0"
    gem.add_development_dependency "jsonschema", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

task :test => %w(test:units)
namespace :test do
  desc "run unit tests"
  Rake::TestTask.new(:units) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/unit/*_test.rb", "test/unit/*/*_test.rb"]
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "paypal_adaptive #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
