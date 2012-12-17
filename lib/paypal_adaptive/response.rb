module PaypalAdaptive
  class Response < Hash    
    def initialize(response={}, env=nil)
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

    # URL to redirect to in order for the user to approve the payment
    #
    # options:
    # * country: default country code for the user
    # * type: mini / light
    def approve_paypal_payment_url(opts = {})
      if opts.is_a?(Symbol) || opts.is_a?(String)
        warn "[DEPRECATION] use approve_paypal_payment_url(:type => #{opts})"
        opts = {:type => opts}
      end
      return nil if self['payKey'].nil?

      if ['mini', 'light'].include?(opts[:type].to_s)
        "#{@paypal_base_url}/webapps/adaptivepayment/flow/pay?expType=#{opts[:type]}&paykey=#{self['payKey']}"
      else
        base = @paypal_base_url
        base = base + "/#{opts[:country]}" if opts[:country]
        "#{base}/webscr?cmd=_ap-payment&paykey=#{self['payKey']}"
      end
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
