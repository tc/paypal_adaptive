require 'json'
require 'net/http'
require 'net/https'

module PaypalAdaptive
  class NoDataError < Exception
  end

  class Request
    def initialize(env = nil)
      @env = env
      config = PaypalAdaptive.config(env)
      @api_base_url = config.api_base_url
      @headers = config.headers
      @ssl_cert_path = config.ssl_cert_path
      @ssl_cert_file = config.ssl_cert_file
      @api_cert_file = config.api_cert_file
    end

    def validate
      #TODO the receiverList field not validating properly

      # @schema_filepath = "../lib/pay_request_schema.json"
      # @schema = File.open(@schema_filepath, "rb"){|f| JSON.parse(f.read)}
      # see page 42 of PP Adaptive Payments PDF for explanation of all fields.
      #JSON::Schema.validate(@data, @schema)
    end

    def pay(data)
      wrap_post(data, "/AdaptivePayments/Pay")
    end

    def payment_details(data)
      wrap_post(data, "/AdaptivePayments/PaymentDetails")
    end

    def set_payment_options(data)
      wrap_post(data, "/AdaptivePayments/SetPaymentOptions")
    end

    def get_payment_options(data)
      wrap_post(data, "/AdaptivePayments/GetPaymentOptions")
    end

    def get_shipping_addresses(data)
      wrap_post(data, "/AdaptivePayments/GetShippingAddresses")
    end

    def preapproval(data)
      wrap_post(data, "/AdaptivePayments/Preapproval")
    end

    def preapproval_details(data)
      wrap_post(data, "/AdaptivePayments/PreapprovalDetails")
    end

    def cancel_preapproval(data)
      wrap_post(data, "/AdaptivePayments/CancelPreapproval")
    end

    def convert_currency(data)
      wrap_post(data, "/AdaptivePayments/ConvertCurrency")
    end

    def refund(data)
      wrap_post(data, "/AdaptivePayments/Refund")
    end

    def execute_payment(data)
      wrap_post(data, "/AdaptivePayments/ExecutePayment")
    end

    def get_verified_status(data)
      wrap_post(data, "/AdaptiveAccounts/GetVerifiedStatus")
    end

    def wrap_post(data, path)
      raise NoDataError unless data

      PaypalAdaptive::Response.new(post(data, path), @env)
    end

    def rescue_error_message(e, message = nil)
      {"responseEnvelope" => {"ack" => "Failure"}, "error" => [{"message" => (message ||= e)}]}
    end

    def post(data, path)
      #hack fix: JSON.unparse doesn't work in Rails 2.3.5; only {}.to_json does..
      api_request_data = JSON.unparse(data) rescue data.to_json
      url = URI.parse @api_base_url
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      if @api_cert_file
        cert = File.read(@api_cert_file)
        http.cert = OpenSSL::X509::Certificate.new(cert)
        http.key = OpenSSL::PKey::RSA.new(cert)
      end
      http.ca_path = @ssl_cert_path unless @ssl_cert_path.blank?
      http.ca_file = @ssl_cert_file unless @ssl_cert_file.blank?

      begin
        response_data = http.post(path, api_request_data, @headers)
        JSON.parse(response_data.body)
      rescue Net::HTTPBadGateway => e
        rescue_error_message(e, "Error reading from remote server.")
      rescue JSON::ParserError => e
        rescue_error_message(e, "Response is not in JSON format.")
      rescue Exception => e
        case e
        when Errno::ECONNRESET
          rescue_error_message(e, "Connection Reset. Request invalid URL.")
        else
          rescue_error_message(e)
        end
      end

    end
  end

end
