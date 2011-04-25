# paypal_adaptive
This gem is a lightweight wrapper for the paypal adaptive payments API.

This is very much a work in progress! Use at your own risk or submit bug fixes :)

Before you need start, read the API manual https://www.x.com/docs/DOC-1531 and check out the forums on http://x.com
It'll be invaluable for parameters and error messages. The gem keeps the request/response as hashes so you will have to
read the manual to make the proper calls. I made a few test cases for further examples at http://github.com/tc/paypal_adaptive/tree/master/test/


## HOWTO
Create paypal_adaptive.yml to your config folder:

    development:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      ssl_cert_file:

    test:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      ssl_cert_file:

    production:
      environment: "production"
      username: "my_production_username"
      password: "my_production_password"
      signature: "my_production_signature"
      application_id: "my_production_app_id"
      ssl_cert_file:

Make the payment request:

    pay_request = PaypalAdaptive::Request.new

    data = {
    "returnUrl" => "http://testserver.com/payments/completed_payment_request", 
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",  
    "receiverList"=>{"receiver"=>[{"email"=>"testpp_1261697850_per@nextsprocket.com", "amount"=>"10.00"}]},
    "cancelUrl"=>"http://testserver.com/payments/canceled_payment_request",
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>"http://testserver.com/payments/ipn_notification"
    }
  
    pay_response = pay_request.pay(data)

    if pay_response.success?
      redirect_to pay_response.approve_paypal_payment_url
    else
      puts pay_response.errors.first['message']
      redirect_to failed_payment_url
    end

---
Once the user goes to pay_response.approve_paypal_payment_url, they will be prompted to login to Paypal for payment.

Upon payment completion page, they will be redirected to http://testserver.com/payments/completed_payment_request.

They can also click cancel to go to http://testserver.com/payments/canceled_payment_request

The actual payment details will be sent to your server via "ipnNotificationUrl"
You have to create a listener to receive POST messages from paypal. I added a Rails metal template in the templates folder which handles the callback.

Additionally, you can make calls to Paypal Adaptive's other APIs:
    payment_details, preapproval, preapproval_details, cancel_preapproval, convert_currency, refund

Input is just a Hash just like the pay method. Refer to the Paypal manual for more details.

### Certificate validation
You can set the location of the .pem file you wish to use for SSL certificate validation in paypal_adaptive.yml
for each environment, e.g.:

    development:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      ssl_cert_file: "/path/to/your/cacert.pem"

If you don't set ssl_cert_file then paypal_adaptive will check for certificates in /etc/ssl/certs if
this location exists, otherwise falling back to the cacert.pem file included with paypal_adaptive.

## Changelog
0.2.0
Thanks to seangaffney for set payment option support.
Thanks to gaelian for ssl cert support.
Changed tests to use relative paths.

0.1.0
Fixed IPN rails metal template by sending the correct params back: ipn.send_back(env['rack.request.form_vars'])
Thanks to github.com/JoN1oP for fixing this.

0.0.5
Added Preapproval preapproval_paypal_payment_url along with test case.

0.0.4
Preapproval now returns a PaypalAdaptive::Response class. Added preapproval test cases.

0.0.3
Renamed PayRequest, PayResponse into Request, Response since other api calls use the class as well.

0.0.2
Fixed initialized constant warning.   

0.0.1
First release.

## Copyright

Copyright (c) 2009 Tommy Chheng. See LICENSE for details.
