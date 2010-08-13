# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class PaypalIpn
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/paypal_ipn/
      request = Rack::Request.new(env)
      params = request.params
      
      ipn = PaypalAdaptive::IpnNotification.new
      ipn.send_back(env['rack.request.form_vars'])
      if ipn.verified?
        #mark transaction as completed in your DB
        output = "Verified."
      else
        output = "Not Verified."
      end

      [200, {"Content-Type" => "text/html"}, [output]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
  
end