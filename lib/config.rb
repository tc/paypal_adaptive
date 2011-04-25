require 'yaml'

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

    attr_accessor :config_filepath, :paypal_base_url, :api_base_url, :headers, :ssl_cert_path, :ssl_cert_file
  
    def initialize(env=nil, config_override=nil)
      if env
        #non-rails env
        @config_filepath = File.join(File.dirname(__FILE__), "..", "config", "paypal_adaptive.yml")
        load(env, config_override)
      else
        @config_filepath = File.join(Rails.root, "config", "paypal_adaptive.yml")
        load(Rails.env, config_override)
      end
    end

    def load(rails_env, config_override)
      config = YAML.load_file(@config_filepath)[rails_env]
      config.merge!(config_override) unless config_override.nil?

      if config["retain_requests_for_test"] == true
        @retain_requests_for_test = true
      else
        pp_env = config['environment'].to_sym

        @ssl_cert_path = nil
        @ssl_cert_file = nil
        @paypal_base_url = PAYPAL_BASE_URL_MAPPING[pp_env]
        @api_base_url = API_BASE_URL_MAPPING[pp_env]
        @headers = {
          "X-PAYPAL-SECURITY-USERID" => config['username'],
          "X-PAYPAL-SECURITY-PASSWORD" => config['password'],
          "X-PAYPAL-SECURITY-SIGNATURE" => config['signature'],
          "X-PAYPAL-APPLICATION-ID" => config['application_id'],
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "JSON",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
        }

        if config['ssl_cert_file'] && config['ssl_cert_file'].length > 0
          @ssl_cert_file = config['ssl_cert_file']
        elsif File.exists?("/etc/ssl/certs")
          @ssl_cert_path = "/etc/ssl/certs"
        else
          @ssl_cert_file = "../cacert.pem"
        end
      end
    end

    def retain_requests_for_test?
      !!@retain_requests_for_test
    end

  end
end
