# paypal_adaptive
This gem is a lightweight wrapper for the paypal adaptive payments API.

This is very much a work in progress! Use at your own risk or submit bug fixes :)

Before you need start, download pp_adaptivepayments.pdf and IPNGuide.pdf from the Paypal's dev site http://x.com
It'll be invaluable in determining how certain things work and error messages.  

## HOWTO

Make the paymenet request:

    pay_request = PaypalAdaptive::PayRequest.new

    data = {
    "returnUrl" => "http://testserver.com/payments/completed_payment_request", 
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",  
    "receiverList"=>{"receiver"=>[{"email"=>"testpp_1261697850_per@nextsprocket.com", "amount"=>"10.00"}]},
    "cancelUrl"=>"http://testserver.com/payments/canceled_payment_request",
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>"http://testserver.com/payments/ipn_notification"
    }
  
    pp_response = pay_request.pay(data)

    if pp_response.success?
      redirect_to pp_response.approve_paypal_payment_url
    else
      puts pp_response.errors.first['message']
      redirect_to failed_payment
    end

---
Once the user goes to pp_response.approve_paypal_payment_url, they will be prompted to login to Paypal for payment.

Upon payment completion page, they will be redirected to http://testserver.com/payments/completed_payment_request.

They can also click cancel to go to http://testserver.com/payments/canceled_payment_request

The actual payment details will be sent to your server via "ipnNotificationUrl"
You have to create a listener to receive POST messages from paypal. I added a Rails metal template in the templates folder which handles the callbcak.


## Copyright

Copyright (c) 2009 Tommy Chheng. See LICENSE for details.
