require 'helper'
require 'json'
require 'jsonschema'

class PayRequestSchemaTest < Test::Unit::TestCase
  def setup
    @schema_filepath = "./lib/pay_request_schema.json"
    @schema = File.open(@schema_filepath, "rb"){|f| JSON.parse(f.read)}
  end
  
  def xtest_valid_simple_pay
    data   = read_json_file("valid_simple_pay_request_1")
    
    #receiverList not validating correctly, is it due to the schema or jsonschema parsing?
    assert_nothing_raised do 
      JSON::Schema.validate(data, @schema)
    end
  end
  
  def test_invalid_simple_pay
    data   = read_json_file("invalid_simple_pay_request_1")
    
    assert_raise JSON::Schema::ValueError do 
      JSON::Schema.validate(data, @schema)
    end
  end
  
  def test_valid_chain_pay
    #TODO
  end

  def test_invalid_chain_pay
    #TODO
  end

  def test_valid_parallel_pay
    #TODO
  end

  def test_invalid_parallel_pay
    #TODO
  end

end