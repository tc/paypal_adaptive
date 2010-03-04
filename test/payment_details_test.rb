require 'helper'
require '../lib/request'

class PaymentDetailsTest < Test::Unit::TestCase
  def setup
    @pay_request = PaypalAdaptive::Request.new("test")
    @payment_details_request = PaypalAdaptive::Request.new("test")
  end
  
  def test_payment_details
    puts "-------"
    puts "payment details"
    data_filepath =  "../test/data/valid_chain_pay_request.json"

    data = read_json_file(data_filepath)
    pp_response = @pay_request.pay(data)
    puts "redirect url to\n #{pp_response.approve_paypal_payment_url}"

    unless pp_response.success?
      puts pp_response.errors
    end

    assert pp_response.success?

    data = {"requestEnvelope"=>{"errorLanguage"=>"en_US"}, "payKey" => pp_response['payKey']}
     
   response =  @payment_details_request.payment_details(data)
   assert_equal 'CREATED', response['status']
  end

end