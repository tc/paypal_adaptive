require 'yaml'
require 'erb'

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

    attr_accessor :paypal_base_url, :api_base_url, :headers, :ssl_cert_path, :ssl_cert_file, :api_cert_file

    def initialize(env=nil, config_override={})
      config = YAML.load(ERB.new(File.new(config_filepath).read).result)[env]
      raise "Could not load settings from config file" unless config
      config.merge!(config_override) unless config_override.nil?

      validate_config(config)

      if config["retain_requests_for_test"] == true
        @retain_requests_for_test = true
      else
        pp_env = config['environment'].to_sym

        @ssl_cert_path = nil
        @ssl_cert_file = nil
        @api_cert_file = nil
        @paypal_base_url = PAYPAL_BASE_URL_MAPPING[pp_env]
        @api_base_url = API_BASE_URL_MAPPING[pp_env]

        # http.rb requires headers to be strings. Protect against ints in paypal_adaptive.yml
        config.update(config){ |key,v| v.to_s }
        @headers = {
          "X-PAYPAL-SECURITY-USERID" => config['username'],
          "X-PAYPAL-SECURITY-PASSWORD" => config['password'],
          "X-PAYPAL-APPLICATION-ID" => config['application_id'],
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "JSON",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
        }
        @headers.merge!({"X-PAYPAL-SECURITY-SIGNATURE" => config['signature']}) if config['signature']
        @ssl_cert_path = config['ssl_cert_path'] unless config['ssl_cert_path'].blank?
        @ssl_cert_file = config['ssl_cert_file'] unless config['ssl_cert_file'].blank?
        @api_cert_file = config['api_cert_file'] unless config['api_cert_file'].blank?
      end
    end

    def validate_config(config)
      raise "No username in paypal_adaptive.yml specified." unless config['username']
      raise "No password in paypal_adaptive.yml specified." unless config['password']
      raise "No application_id in paypal_adaptive.yml specified." unless config['application_id']

      true
    end

    def config_filepath
      if defined?(Rails)
        Rails.root.join("config", "paypal_adaptive.yml")
      else
        File.join(File.dirname(__FILE__), "..", "..", "config", "paypal_adaptive.yml")
      end
    end

    def retain_requests_for_test?
      !!@retain_requests_for_test
    end
  end

  def self.config(env = nil)
    env ||= default_env_for_config
    raise "Please provide an environment" unless env
    @configs ||= Hash.new
    @configs[env] ||= Config.new(env)
  end

  private

  def self.default_env_for_config
    defined?(Rails) ? Rails.env : nil
  end
end
