require 'test_helper'

class PaymentOptionsTest < Test::Unit::TestCase
  def setup
    @pay_key     = nil
    @pay_request = PaypalAdaptive::Request.new("test")
  end

  def test_payment_options
    puts "-------"
    puts "set payment options"

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

    puts "-------"
    puts "get payment options"

    # /GetPaymentOptions
    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","valid_get_payment_options_request.json")

    data = read_json_file(data_filepath)
    data["payKey"] = @pay_key

    pp_response = @pay_request.get_payment_options(data)

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?

    assert_equal pp_response["senderOptions"]["requireShippingAddressSelection"],                 "true"
    assert_equal pp_response["receiverOptions"].first["invoiceData"]["item"].first["identifier"], "1"
    assert_equal pp_response["receiverOptions"].first["invoiceData"]["item"].first["name"],       "Sample Product"
    assert_equal pp_response["receiverOptions"].first["invoiceData"]["item"].first["itemCount"],  "1"
    assert_equal pp_response["receiverOptions"].first["invoiceData"]["item"].first["itemPrice"],  "10.00"
    assert_equal pp_response["receiverOptions"].first["invoiceData"]["item"].first["price"],      "10.00"
    assert_equal pp_response["receiverOptions"].first["invoiceData"]["totalShipping"],            "0.00"
  end

  def read_json_file(filepath)
    File.open(filepath,   "rb"){|f| JSON.parse(f.read)}
  end
end
