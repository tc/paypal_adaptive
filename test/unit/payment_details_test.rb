require 'test_helper'

class PaymentDetailsTest < Test::Unit::TestCase
  def setup
    @pay_key     = nil
    @pay_request = PaypalAdaptive::Request.new("test")
  end

  def test_payment_details
    puts "-------"
    puts "payment details"

    # /Pay
    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","valid_chain_pay_request.json")

    data = read_json_file(data_filepath)

    pp_response = @pay_request.pay(data)
    @pay_key = pp_response['payKey']

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?

    # /PaymentDetails
    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","valid_payment_details_request.json")

    data = read_json_file(data_filepath)
    data["payKey"] = @pay_key

    pp_response = @pay_request.payment_details(data)

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?

    assert_equal 'CREATED', pp_response['status']
  end

  def read_json_file(filepath)
    File.open(filepath,   "rb"){|f| JSON.parse(f.read)}
  end
end
