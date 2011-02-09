require 'rubygems'
require "yaml"
require 'JSON'
require 'test/unit'
require "request"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class Test::Unit::TestCase

  def read_json_file(filepath)
    File.open("./test/data/#{filepath}.json", "rb"){|f| JSON.parse(f.read)}
  end
  
end
