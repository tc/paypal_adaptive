require 'net/http'
require 'net/https'
require 'json'
require 'rack/utils'

module PaypalAdaptive
  class IpnNotification

    def initialize(env=nil)
      config = PaypalAdaptive.config(env)
      @paypal_base_url = config.paypal_base_url
      @ssl_cert_path = config.ssl_cert_path
      @ssl_cert_file = config.ssl_cert_file
      @api_cert_file = config.api_cert_file
      @verify_mode = config.verify_mode
    end

    def send_back(data)
      data = "cmd=_notify-validate&#{data}"
      path = "#{@paypal_base_url}/cgi-bin/webscr"
      url = URI.parse path
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = @verify_mode
      http.ca_path = @ssl_cert_path unless @ssl_cert_path.nil?

      if @api_cert_file
        cert = File.read(@api_cert_file)
        http.cert = OpenSSL::X509::Certificate.new(cert)
        http.key = OpenSSL::PKey::RSA.new(cert)
      end
      http.ca_path = @ssl_cert_path unless @ssl_cert_path.blank?
      http.ca_file = @ssl_cert_file unless @ssl_cert_file.blank?

      req = Net::HTTP::Post.new(url.request_uri)
      req.set_form_data(Rack::Utils.parse_nested_query(data))
      req['Accept-Encoding'] = 'identity'
      response_data = http.request(req).body

      @verified = response_data == "VERIFIED"
    end

    def verified?
      @verified
    end

  end
end
