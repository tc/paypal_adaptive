module PaypalAdaptive
  class Response < Hash    
    def initialize(response, env=nil)
      config = PaypalAdaptive.config(env)
      @paypal_base_url = config.paypal_base_url
      
      self.merge!(response)
    end
    
    def success?
      !! (self['responseEnvelope']['ack'].to_s =~ /^Success$/i &&
        !(self['paymentExecStatus'].to_s =~ /^ERROR$/i))
    end
    
    def errors
      if success?
        return []
      else
        errors = self['error']
        errors ||= self['payErrorList']['payError'].collect { |e| e['error'] } rescue nil
        errors
      end
    end

    def error_message
      message = errors.first['message'] rescue nil
    end

    def approve_paypal_payment_url(type=nil)
      if self['payKey'].nil?
        return nil
      elsif ['mini', 'light'].include?(type.to_s)
        return "#{@paypal_base_url}/webapps/adaptivepayment/flow/pay?expType=#{type.to_s}&paykey=#{self['payKey']}"
      end
      
      "#{@paypal_base_url}/webscr?cmd=_ap-payment&paykey=#{self['payKey']}"
    end

    def preapproval_paypal_payment_url
      self['preapprovalKey'].nil? ? nil : "#{@paypal_base_url}/webscr?cmd=_ap-preapproval&preapprovalkey=#{self['preapprovalKey']}"
    end

    # workaround for rails 3.1.1, see https://github.com/tc/paypal_adaptive/issues/23
    def nested_under_indifferent_access
      self
    end
  end
end
