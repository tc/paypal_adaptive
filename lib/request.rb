require 'abstract_request'

module PaypalAdaptive
  class PaypalRequest < PaypalAdaptive::AbstractRequest

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
      PaypalAdaptive::PayResponse.new(response_data, @env)
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
  end

end