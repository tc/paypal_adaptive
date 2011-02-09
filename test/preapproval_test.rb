require "time"
require 'helper'
require '../lib/request'

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
    data_filepath =  "../test/data/valid_preapproval.json"

    data = read_json_file(data_filepath)
		set_dates(data)

    pp_response = @preapproval_request.preapproval(data)
    puts "preapproval code is #{pp_response['preapprovalKey']}"

    assert pp_response.success?
    assert_not_nil pp_response.preapproval_paypal_payment_url
    assert_not_nil pp_response['preapprovalKey']
  end


  def test_invalid_preapproval
    puts "-------"
    puts "invalid"
    data_filepath =  "../test/data/invalid_preapproval.json"

    data = read_json_file(data_filepath)
    pp_response = @preapproval_request.preapproval(data)
    puts "error message is #{pp_response.error_message}"

    assert pp_response.success? == false
    assert_nil pp_response.preapproval_paypal_payment_url
    assert_nil pp_response['preapprovalKey']
  end

end