require 'test_helper'

class PayRequestTest < Test::Unit::TestCase
  def setup
    @pay_request = PaypalAdaptive::Request.new("test")
  end

  def test_valid_simple_pay
    data = read_json_file("valid_simple_pay_request_1.json")
    assert_success_response @pay_request.pay(data)
  end
  
  def test_invalid_simple_pay
    data = read_json_file("invalid_simple_pay_request_1.json")
    assert_error_response "580022", @pay_request.pay(data)
  end
  
  def test_valid_chain_pay
    data = read_json_file("valid_chain_pay_request.json")
    assert_success_response @pay_request.pay(data)
  end

  def test_invalid_chain_pay
    data = read_json_file("invalid_chain_pay_request.json")
    assert_error_response "579017", @pay_request.pay(data)
  end

  def test_valid_parallel_pay
    data = read_json_file("valid_parallel_pay_request.json")
    assert_success_response @pay_request.pay(data)
  end

  def test_invalid_parallel_pay
    data = read_json_file("invalid_parallel_pay_request.json")
    assert_error_response "579040", @pay_request.pay(data)
  end
  
  def test_preapproval
    #TODO
  end

  def test_preapproval_details
    #TODO
  end
  
  def test_cancel_preapproval
    #TODO
  end

  def test_convert_currency
    #TODO
  end

  def test_refund
    #TODO
  end

  def read_json_file(filename)
    JSON.parse(File.read(File.join(File.dirname(__FILE__),"..","data",filename)))
  end

  APPROVE_URL_PATTERN = %r{^https://www.sandbox.paypal.com/webscr\?cmd=_ap-payment&paykey=AP-}
  APPROVE_URL_PATTERN_JP = %r{^https://www.sandbox.paypal.com/jp/webscr\?cmd=_ap-payment&paykey=AP-}
  MINI_APPROVE_URL_PATTERN = %r{^https://www.sandbox.paypal.com/webapps/adaptivepayment/flow/pay\?expType=mini&paykey=AP-}
  
  def assert_success_response(pp_response)
    assert_equal true, pp_response.success?, "expected success: #{pp_response.inspect}"
    assert_match APPROVE_URL_PATTERN, pp_response.approve_paypal_payment_url
    assert_match APPROVE_URL_PATTERN_JP, pp_response.approve_paypal_payment_url(:country => :jp)
    assert_match MINI_APPROVE_URL_PATTERN, pp_response.approve_paypal_payment_url('mini')
    assert_match MINI_APPROVE_URL_PATTERN, pp_response.approve_paypal_payment_url(:type => 'mini')
  end

  def assert_error_response(error_code, pp_response)
    assert_equal false, pp_response.success?
    pp_errors = pp_response.errors.first
    assert_equal "Error", pp_errors["severity"]
    assert_equal error_code, pp_errors["errorId"]
  end
end
