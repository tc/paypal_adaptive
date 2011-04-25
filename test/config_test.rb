require 'helper'
require '../lib/request'

class ConfigTest < Test::Unit::TestCase
  def test_ssl_cert_logic
    @config = PaypalAdaptive::Config.new("test", { "ssl_cert_file" => "" })
    assert @config.ssl_cert_file == "../cacert.pem"
  end

  def test_ssl_cert_file
    @config = PaypalAdaptive::Config.new("test", { "ssl_cert_file" => "data/dummy_cacert.pem" })
    assert @config.ssl_cert_file == "data/dummy_cacert.pem"
    assert @config.ssl_cert_path == nil
  end
end