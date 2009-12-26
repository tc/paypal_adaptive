require 'net/http'
require 'net/https'
require 'json'
require 'config'
require 'pay_response'

module PaypalAdaptive
  class NoDataError < Exception
  end
  
  class PayRequest
    attr_accessor :pay_key
    attr_accessor :errors
    attr_accessor :env
    
    def initialize(env = nil)
      @env = env
      @@config ||= PaypalAdaptive::Config.new(@env)
      @@api_base_url ||= @@config.api_base_url 
      @@headers ||= @@config.headers
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
      
      call_api(data, "/AdaptivePayments/Pay")
    end
    
    def payment_details(data)
      raise NoDataError unless data
      
      call_api(data, "/AdaptivePayments/PaymentDetails")
    end

    def preapproval(data)
      raise NoDataError unless data
      
      call_api(data, "/AdaptivePayments/Preapproval")
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
      data = JSON.unparse(data)
      url = URI.parse @@api_base_url
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = (url.scheme == 'https')
      
      resp, response_data = http.post(path, data, @@headers)

      puts response_data
      
      pp_response = PaypalAdaptive::PayResponse.new(response_data, @env)
    end
  end
end