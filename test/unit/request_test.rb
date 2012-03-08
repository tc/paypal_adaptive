require 'test_helper'

class RequestTest < Test::Unit::TestCase
  def setup
    @schema_filepath =  File.join(File.dirname(__FILE__),"..", "..", "lib","pay_request_schema.json")
    @schema = File.open(@schema_filepath, "rb"){|f| JSON.parse(f.read)}
  end

  def test_post_should_return_hash
    request = PaypalAdaptive::Request.new('test')
    response = request.post({:data => true}, '/AdaptivePayments/Pay')
    assert_instance_of Hash, response
  end

  def test_post_should_return_hash_when_request_is_invalid
    request = PaypalAdaptive::Request.new('test')
    response = request.post({:data => true}, '/some-random-url')
    assert_instance_of Hash, response
  end

  def test_post_shoudl_return_error_message_when_request_is_invalid
    request = PaypalAdaptive::Request.new('test')
    response = request.post({:data => true}, '/some-random-url')
    assert_not_nil response["error"][0]["message"]
  end
  
end
