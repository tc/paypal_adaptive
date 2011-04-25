require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  def test_ssl_cert_logic
    @config = PaypalAdaptive::Config.new("test", { "ssl_cert_file" => "" })

    assert_equal File.join("..","cacert.pem"), @config.ssl_cert_file
  end

  def test_ssl_cert_file
    @config = PaypalAdaptive::Config.new("test", { "ssl_cert_file" => "data/dummy_cacert.pem" })
    assert_equal File.join("data", "dummy_cacert.pem"), @config.ssl_cert_file
    assert_equal nil, @config.ssl_cert_path
  end
end
