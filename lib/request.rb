require 'json'
require 'config'
require 'net/http'
require 'net/https'
require 'response'

module PaypalAdaptive
  class NoDataError < Exception
  end

  class Request
    def initialize(env = nil)
      @env = env
      @@config ||= PaypalAdaptive::Config.new(@env)
      @@api_base_url ||= @@config.api_base_url
      @@headers ||= @@config.headers
      @@ssl_cert_path ||= @@config.ssl_cert_path
      @@ssl_cert_file ||= @@config.ssl_cert_file
    end

    def validate
      #TODO the receiverList field not validating properly

      # @@schema_filepath = "../lib/pay_request_schema.json"
      # @@schema = File.open(@@schema_filepath, "rb"){|f| JSON.parse(f.read)}
      # see page 42 of PP Adaptive Payments PDF for explanation of all fields.
      #JSON::Schema.validate(@data, @@schema)
    end

    def pay(data)
      raise NoDataError unless data

      response_data = call_api(data, "/AdaptivePayments/Pay")
      PaypalAdaptive::Response.new(response_data, @env)
    end

    def set_payment_options(data)
      raise NoDataError unless data

      response_data = call_api(data, "/AdaptivePayments/SetPaymentOptions")
      PaypalAdaptive::Response.new(response_data, @env)
    end

    def payment_details(data)
      raise NoDataError unless data

      call_api(data, "/AdaptivePayments/PaymentDetails")
    end

    def preapproval(data)
      raise NoDataError unless data

      response_data = call_api(data, "/AdaptivePayments/Preapproval")
      PaypalAdaptive::Response.new(response_data, @env)
    end

    def preapproval_details(data)
      raise NoDataError unless data

      call_api(data, "/AdaptivePayments/PreapprovalDetails")
    end

    def cancel_preapproval(data)
      raise NoDataError unless data

      call_api(data, "/AdaptivePayments/CancelPreapproval")
    end

    def convert_currency(data)
      raise NoDataError unless data

      call_api(data, "/AdaptivePayments/ConvertCurrency")
    end

    def refund(data)
      raise NoDataError unless data

      call_api(data, "/AdaptivePayments/Refund")
    end

    def call_api(data, path)
      #hack fix: JSON.unparse doesn't work in Rails 2.3.5; only {}.to_json does..
      api_request_data = JSON.unparse(data) rescue data.to_json
      url = URI.parse @@api_base_url
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_path = @@ssl_cert_path unless @@ssl_cert_path.nil?
      http.ca_file = @@ssl_cert_file unless @@ssl_cert_file.nil?

      resp, response_data = http.post(path, api_request_data, @@headers)

      JSON.parse(response_data)
    end
  end

end
