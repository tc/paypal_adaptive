module PaypalAdaptive
  class Config
    PAYPAL_BASE_URL_MAPPING = {
      :production => "https://www.paypal.com",
      :sandbox => "https://www.sandbox.paypal.com",
      :beta_sandbox => "https://www.beta-sandbox.paypal.com"
    } unless defined? PAYPAL_BASE_URL_MAPPING

    API_BASE_URL_MAPPING = {
      :production => "https://svcs.paypal.com",
      :sandbox => "https://svcs.sandbox.paypal.com",
      :beta_sandbox => "https://svcs.beta-sandbox.paypal.com"
    } unless defined? API_BASE_URL_MAPPING

    attr_accessor :config_filepath, :paypal_base_url, :api_base_url, :headers
  
    def initialize(env=nil)
      if env
        #non-rails env
        @config_filepath = "../config/paypal_adaptive.yml"
        load(env)
      else
        @config_filepath = File.join(Rails.root, "config/paypal_adaptive.yml")
        load(Rails.env)
      end
    end

    def load(rails_env)
      config= YAML.load_file(@config_filepath)[rails_env] || {}

      if config["retain_requests_for_test"] == true
        @retain_requests_for_test = true
      else
        pp_env = (config['environment'] || ENV['PAYPAL_ADAPTIVE_ENVIRONMENT']).to_sym

        @paypal_base_url = PAYPAL_BASE_URL_MAPPING[pp_env]
        @api_base_url = API_BASE_URL_MAPPING[pp_env]
        @headers = {
          "X-PAYPAL-SECURITY-USERID" => config['username'] || ENV['PAYPAL_ADAPTIVE_USERNAME'],
          "X-PAYPAL-SECURITY-PASSWORD" => config['password'] || ENV['PAYPAL_ADAPTIVE_PASSWORD'],
          "X-PAYPAL-SECURITY-SIGNATURE" => config['signature'] || ENV['PAYPAL_ADAPTIVE_SIGNATURE'],
          "X-PAYPAL-APPLICATION-ID" => config['application_id'] || ENV['PAYPAL_ADAPTIVE_APPLICATION_ID'],
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "JSON",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
        }
      end
    end

    def retain_requests_for_test?
      !!@retain_requests_for_test
    end

  end
end
