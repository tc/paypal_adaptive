module PaypalAdaptive
  class Response < Hash    
    def initialize(response, env=nil)
      @@config ||= PaypalAdaptive::Config.new(env)
      @@paypal_base_url ||= @@config.paypal_base_url
      
      self.merge!(response)
    end
    
    def success?
      self['responseEnvelope']['ack'] == 'Success'
    end
    
    def errors
      if success?
        return []
      else
        self['error']
      end
    end

    def error_message
      if success?
        return nil
      else
        self['error'].first['message'] rescue nil
      end
    end

    def approve_paypal_payment_url(type=nil)
      if self['payKey'].nil?
        return nil
      elsif ['mini', 'light'].include?(type.to_s)
        return "#{@@paypal_base_url}/webapps/adaptivepayment/flow/pay?expType=#{type.to_s}&paykey=#{self['payKey']}"
      end
      
      "#{@@paypal_base_url}/webscr?cmd=_ap-payment&paykey=#{self['payKey']}"
    end

    def preapproval_paypal_payment_url
      self['preapprovalKey'].nil? ? nil : "#{@@paypal_base_url}/webscr?cmd=_ap-preapproval&preapprovalkey=#{self['preapprovalKey']}"
    end
  end
end
