# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "paypal_adaptive/version"

Gem::Specification.new do |s|
  s.name        = "paypal_adaptive"
  s.version     = PaypalAdaptive::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tommy Chheng"]
  s.email       = ["tommy.chheng@gmail.com"]
  s.homepage    = "http://github.com/tc/paypal_adaptive"
  s.summary     = "Lightweight wrapper for Paypal's Adaptive Payments API"
  s.description = "Lightweight wrapper for Paypal's Adaptive Payments API"

  s.add_dependency("json", "~>1.6.0")
  s.add_dependency("jsonschema", "~>2.0.0")
  s.add_dependency("rake", "~>0.8")

  s.rubyforge_project = "paypal_adaptive"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
