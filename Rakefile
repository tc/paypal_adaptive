require 'rubygems'
require 'rake'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lottay-paypal_adaptive"
    gem.summary = %Q{initial import}
    gem.description = %Q{Lightweight wrapper for Paypal's Adaptive Payments API.}
    gem.email = "rosshale@gmail.com"
    gem.homepage = "http://github.com/lottay/paypal_adaptive"
    gem.authors = ["Tommy Chheng", "Ross Hale"]
    gem.add_development_dependency "json", ">= 0"
    gem.add_development_dependency "jsonschema", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lottay-paypal_adaptive #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
