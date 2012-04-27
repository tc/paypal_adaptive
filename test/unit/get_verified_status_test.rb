require 'test_helper'

class GetVerifiedStatusTest < Test::Unit::TestCase
  def setup
    @get_verified_status_request = PaypalAdaptive::Request.new("test")
  end
  
  def test_get_verified_status
    puts "-------"
    puts "get_verified_status"

    data_filepath =  File.join(File.dirname(__FILE__),"..", "data","verified_get_verified_status_request.json")

    data = read_json_file(data_filepath)
    pp_response = @get_verified_status_request.get_verified_status(data)

    puts "account status: #{pp_response['accountStatus']}"
    assert_equal true, pp_response.success?
  end

  def read_json_file(filepath)
    File.open(filepath,   "rb"){|f| JSON.parse(f.read)}
  end
end
