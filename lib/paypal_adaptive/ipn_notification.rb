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
      http.ca_path = @ssl_cert_path unless @ssl_cert_path.nil? || @ssl_cert_path.length == 0
      http.ca_file = @ssl_cert_file unless @ssl_cert_file.nil? || @ssl_cert_file.length == 0

      req = Net::HTTP::Post.new(url.request_uri)
      # we don't want #set_form_data to create a hash and get our
      # response out of order; Paypal IPN docs explicitly state that
      # the contents of #send_back must be in the same order as they
      # were recieved
      req.body = data
      req.content_type = 'application/x-www-form-urlencoded'
      req['Accept-Encoding'] = 'identity'
      response_data = http.request(req).body

      @verified = response_data == "VERIFIED"
    end

    def verified?
      @verified
    end

  end
end
