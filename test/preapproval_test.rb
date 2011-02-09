require "time"
require 'helper'

class PreapprovalTest < Test::Unit::TestCase
  def setup
    @preapproval_request = PaypalAdaptive::Request.new("test")
  end

	def set_dates(data)
		data["startingDate"] = Time.now.utc.iso8601
		data["endingDate"] = (Time.now.utc + 20*24*3600).iso8601
	end

  def test_preapproval
    puts "-------"
    puts "valid test"
    data = read_json_file("valid_preapproval")
		set_dates(data)

    pp_response = @preapproval_request.preapproval(data)
    puts "preapproval code is #{pp_response['preapprovalKey']}"

    assert pp_response.success?
    assert_not_nil pp_response.preapproval_paypal_payment_url
    assert_not_nil pp_response['preapprovalKey']
  end

	class Logger
		attr_accessor :path, :request_data, :headers, :status, :response_data
		def request(path, request_data, headers)
			@path, @request_data, @headers = path, request_data, headers
		end

		def response(status, response_data)
			@status, @response_data = status.code.to_i, response_data
		end
	end

  def test_invalid_preapproval_with_logger
    data = read_json_file("invalid_preapproval")
		logger = Logger.new
    pp_response = @preapproval_request.preapproval(data.merge(:logger => logger))

    assert pp_response.success? == false
		assert logger.path == "/AdaptivePayments/Preapproval"
		assert logger.request_data == "{\"cancelUrl\":\"http://127.0.0.1:3000/payments/canceled_payment_request\",\"endingDate\":\"2010-12-13T07dfg0000.000Z\",\"returnUrl\":\"http://127.0.0.1:3000/payments/completed_payment_request\",\"maxTotalAmountOfAllPayments\":\"1500.00\",\"startingDate\":\"2010-07-13T07sdf00.000Z\",\"maxNumberOfPayments\":\"30\",\"requestEnvelope\":{\"errorLanguage\":\"en_US\"},\"actionType\":\"PAY\",\"currencyCode\":\"USD\"}"
		assert logger.headers == {"X-PAYPAL-RESPONSE-DATA-FORMAT"=>"JSON", "X-PAYPAL-SANDBOX-EMAIL-ADDRESS"=>"andy@lottay.com", "X-PAYPAL-REQUEST-DATA-FORMAT"=>"JSON", "X-PAYPAL-SECURITY-USERID"=>"andy_1246488382_biz_api1.lottay.com", "X-PAYPAL-DEVICE-IPADDRESS"=>"0.0.0.0", "X-PAYPAL-SECURITY-PASSWORD"=>"1246488389", "X-PAYPAL-APPLICATION-ID"=>"APP-80W284485P519543T", "X-PAYPAL-SECURITY-SIGNATURE"=>"AHCkey.eVc0sNgG3SP.iiLKXx5EmALu43DmEPM6wmWg.snEFzyBrSfE2"}
		assert logger.status == 200
		assert logger.response_data =~ /responseEnvelope/
		assert logger.response_data =~ /Error in parsing time zone/
	end

  def test_invalid_preapproval
    puts "-------"
    puts "invalid"
    data = read_json_file("invalid_preapproval")
    pp_response = @preapproval_request.preapproval(data)
    puts "error message is #{pp_response.error_message}"

    assert pp_response.success? == false
    assert_nil pp_response.preapproval_paypal_payment_url
    assert_nil pp_response['preapprovalKey']
  end
end