require 'test_helper'

class GetShippingAddressesTest < Test::Unit::TestCase
  def setup
    @pay_key     = nil
    @pay_request = PaypalAdaptive::Request.new("test")
  end

  def test_get_shipping_addresses
    puts "-------"
    puts "get shipping addresses"

    # /Pay
    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","valid_simple_pay_request_1.json")

    data = read_json_file(data_filepath)
    data["actionType"] = "CREATE"

    pp_response = @pay_request.pay(data)
    @pay_key = pp_response['payKey']

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?

    # /SetPaymentOptions
    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","valid_set_payment_options_request.json")

    data = read_json_file(data_filepath)
    data["payKey"] = @pay_key

    pp_response = @pay_request.set_payment_options(data)

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?

    # /GetShippingAddresses
    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","valid_get_shipping_addresses_request.json")

    data = read_json_file(data_filepath)
    data["key"] = @pay_key

    pp_response = @pay_request.get_shipping_addresses(data)

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?
  end

  def read_json_file(filepath)
    File.open(filepath,   "rb"){|f| JSON.parse(f.read)}
  end
end
