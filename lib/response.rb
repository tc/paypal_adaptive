module PaypalAdaptive
  class Response    
    def initialize(response, env=nil)
      @@config ||= PaypalAdaptive::Config.new(env)
      @@paypal_base_url ||= @@config.paypal_base_url
      
      @json_response = response
    end
    
    def success?
      @json_response['responseEnvelope']['ack'] == 'Success'
    end
    
    def pay_key
      @json_response['payKey']
    end
    
    def errors
      if success?
        return []
      else
        @json_response['error']
      end
    end
    
    def approve_paypal_payment_url
      "#{@@paypal_base_url}/webscr?cmd=_ap-payment&paykey=#{pay_key}"
    end
  end
end