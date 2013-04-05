$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "test/unit"
require "json"
require "jsonschema"
require 'paypal_adaptive'
require 'active_support/core_ext/string'
require 'webmock/minitest'

WebMock.allow_net_connect!
