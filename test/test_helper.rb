$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "test/unit"
require "json"
require "jsonschema"
require 'paypal_adaptive'
