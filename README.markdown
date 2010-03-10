# paypal_adaptive
This gem is a lightweight wrapper for the paypal adaptive payments API.

This is very much a work in progress! Use at your own risk or submit bug fixes :)

Before you need start, read the API manual https://www.x.com/docs/DOC-1531 and check out the forums on http://x.com
It'll be invaluable for parameters and error messages. The gem keeps the request/response as hashes so you will have to
read the manual to make the proper calls. I made a few test cases for further examples at http://github.com/tc/paypal_adaptive/tree/master/test/

## Changes to the Lottay Version
This branch adds support for PayPal Adaptive Accounts.  An Adaptive Accounts request looks very similar to the Pay Request.
You simply post a hash of signup parameters to PayPal using the "create_account" method, and receive a URL to which you redirect the user to finish signup.

See the unit tests in "create_account_test.rb" for a good example.

###Installation Instructions
Install the gem:
    sudo gem install lottay-paypal_adaptive --source http://gemcutter.org
In environment.rb:
    require 'paypal_adaptive'

## HOWTO
Create paypal_adaptive.yml to your config folder:
    development:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      sandbox_email: "paypal_account_email_with_your_sandbox_account"

    test:
      environment: "sandbox"
      username: "sandbox_username"
      password: "sandbox_password"
      signature: "sandbox_signature"
      application_id: "sandbox_app_id"
      sandbox_email: "paypal_account_email_with_your_sandbox_account"

    production:
      environment: "production"
      username: "my_production_username"
      password: "my_production_password"
      signature: "my_production_signature"
      application_id: "my_production_app_id"

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
      redirect_to pp_response.approve_paypal_payment_url
    else
      puts pay_response.errors.first['message']
      redirect_to failed_payment_url
    end

---
Once the user goes to pp_response.approve_paypal_payment_url, they will be prompted to login to Paypal for payment.

Upon payment completion page, they will be redirected to http://testserver.com/payments/completed_payment_request.

They can also click cancel to go to http://testserver.com/payments/canceled_payment_request

The actual payment details will be sent to your server via "ipnNotificationUrl"
You have to create a listener to receive POST messages from paypal. I added a Rails metal template in the templates folder which handles the callback.

Additionally, you can make calls to Paypal Adaptive's other APIs:
    payment_details, preapproval, preapproval_details, cancel_preapproval, convert_currency, refund

Input is just a Hash just like the pay method. Refer to the Paypal manual for more details.

## Changelog
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
