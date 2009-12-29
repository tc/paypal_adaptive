require 'helper'
require '../lib/request'

class PayRequestTest < Test::Unit::TestCase
  def setup
    @pay_request = PaypalAdaptive::Request.new("test")
  end
  
  def test_valid_simple_pay
    puts "-------"
    puts "simple"

    data_filepath =  "../test/data/valid_simple_pay_request_1.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)

    puts "redirect url to\n #{pp_response.approve_paypal_payment_url}"
    assert pp_response.success?
  end
  
  def test_invalid_simple_pay
    data_filepath =  "../test/data/invalid_simple_pay_request_1.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)
    puts pp_response.errors
    assert pp_response.success? == false
  end
  
  def test_valid_chain_pay
    puts "-------"
    puts "chain"
    data_filepath =  "../test/data/valid_chain_pay_request.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)
    puts "redirect url to\n #{pp_response.approve_paypal_payment_url}"

    unless pp_response.success?
      puts pp_response.errors
    end
    
    assert pp_response.success?
  end

  def test_invalid_chain_pay
    data_filepath =  "../test/data/invalid_chain_pay_request.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)
    puts pp_response.errors
    assert pp_response.success? == false
  end

  def test_valid_parallel_pay
    puts "-------"
    puts "parallel"

    data_filepath =  "../test/data/valid_chain_pay_request.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)
    puts "redirect url to\n #{pp_response.approve_paypal_payment_url}"
    assert pp_response.success?
  end

  def test_invalid_parallel_pay
    data_filepath =  "../test/data/invalid_parallel_pay_request.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)
    puts pp_response.errors
    assert pp_response.success? == false
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

  def read_json_file(filepath)
    File.open(filepath,   "rb"){|f| JSON.parse(f.read)}
  end
  
end