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
      api_cert_file:

    test:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      api_cert_file: "/path/to_cert"

    production:
      environment: "production"
      username: "my_production_username"
      password: "my_production_password"
      signature: "my_production_signature"
      application_id: "my_production_app_id"
      api_cert_file: "/path/to_cert"

You can also use ENV variables when specifying your configuration. eg.
```<%= ENV[''paypal.username'] %>```

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
      redirect_to pay_response.preapproval_paypal_payment_url
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

### Using the embedded payment flow
Instead of redirecting to the url from ```redirect_to pay_response.approve_paypal_payment_url``` you can generate the action url for your
form by using ```pay_response.approve_paypal_payment_url 'MY TYPE' ``` The two types that are supported for embedded payment are 'light' and 'mini'
More information about these types can be found here https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_APIntro

### Certificate validation
You can set the location of the key file you downloaded from PayPal, in paypal_adaptive.yml
for each environment, e.g.:

    development:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      api_cert_file: "/path/to/your/private.key"

The api_cert_file should point to your cert_key_pem.txt that is downloaded through the paypal developer interface. It will contain a section that specifies the RSA private key and another section that specifies a certificate. If this is left empty, paypal_adaptive will attempt to use the signature method of validation with PayPal, so your signature config must not be nil.

## Changelog
0.3.4 
Locale specific paypal urls and improved testing. changed approve_paypal_payment_url method signature with deprecation warning. thanks mreinsch.

0.3.3
Handle JSON parsing error. Added validation for config.

0.3.2
Added support to api certificate since ssl_cert_file config is now used to set CA Authority. thanks jimbocortes

0.3.1
Update json dependency to use ~>1.0 so any version 1.X will work.

0.3.0
ssl_cert_file fixes from eddroid. get_verified_status function from bundacia.

0.2.9
Fixed cert issues in last release. Exception handling for connection. 

0.2.8
Cert fixes and ruby 1.9.3 files. Thanks tonyla.

0.2.7
Refactored config file handling for better non-Rails support, thanks mreinsch and dave-thompson.

0.2.6
Fix for using correct status field in pre-approval, thanks nbibler. Fix for ruby 1.9.3, thanks deepj.

0.2.5
Fix for embedded payments, thanks rafaelivan.  Fix for Rails 3.1.1, thanks synth.

0.2.4
Support for embedded payments. Issue #21 thanks rafaelivan. Shipping address, wrapper methods has return response object. Issue #22 thanks tsmango.

0.2.3
Using bundler for gem creation. Moved all code to paypal_adaptive dir.  Added ExecutePayment call to request. Thanks Roger Neel.

0.2.2
Added support for ERB in the config file. Thanks DanielVartanov.

0.2.1
Fixed SSL bug. Thanks gaelian.

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
