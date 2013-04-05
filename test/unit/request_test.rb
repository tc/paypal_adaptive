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

  def test_post_should_return_error_message_when_request_is_invalid
    request = PaypalAdaptive::Request.new('test')
    response = request.post({:data => true}, '/some-random-url')
    assert_instance_of Hash, response
    assert_equal "Connection Reset. Request invalid URL.", response["error"][0]["message"]
  end

  def test_post_should_return_error_details_when_response_is_invalid
    WebMock.disable_net_connect!
    stub_request(:post, "https://svcs.sandbox.paypal.com/some-random-url").
      to_return(:status => [500, "Internal Server Error"], :body => "Something went wrong")
    request = PaypalAdaptive::Request.new('test')
    response = request.post({:data => true}, '/some-random-url')
    assert_instance_of Hash, response
    error = response["error"].first
    assert_instance_of Hash, error
    assert_equal "Response is not in JSON format.", error["message"]
    assert_equal "500", error["details"]["httpCode"]
    assert_equal "Internal Server Error", error["details"]["httpMessage"]
    assert_equal "Something went wrong", error["details"]["httpBody"]
  ensure
    WebMock.allow_net_connect!
  end
end
