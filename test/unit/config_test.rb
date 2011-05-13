require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  def test_set_ssl_cert_file
    @config = PaypalAdaptive::Config.new("test", { "ssl_cert_file" => "/path/to/cacert.pem" })
    assert_equal "/path/to/cacert.pem", @config.ssl_cert_file
    assert_equal nil, @config.ssl_cert_path
  end

  def test_default_ssl_cert_file
    @config = PaypalAdaptive::Config.new("test", { "ssl_cert_file" => "" })
    assert File.exists?(@config.ssl_cert_file)
    assert_equal nil, @config.ssl_cert_path
  end
end
