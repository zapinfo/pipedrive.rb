# frozen_string_literal: true

module Pipedrive
  class Base
    def self.validate_args(api_token:, oauth_credentials:)
      return if api_token.present?

      if oauth_credentials
        raise 'oauth_credentials must be a Hash' unless oauth_credentials.is_a?(Hash)

        %i[access_token api_domain].each do |key|
          unless oauth_credentials[key].present?
            raise "oauth_credentials hash must include :#{key} value"
          end
        end

        return
      end

      raise 'api_token or oauth_credentials must be set'
    end

    def initialize(api_token: ::Pipedrive.api_token, oauth_credentials: ::Pipedrive.oauth_credentials)
      self.class.validate_args(api_token: api_token, oauth_credentials: oauth_credentials)
      @api_token = api_token
      @oauth_credentials = oauth_credentials
    end

    def make_api_call(*args)
      params = args.extract_options!
      method = args[0]
      raise 'method param missing' unless method.present?

      url = build_url(args, params.delete(:fields_to_select))
      begin
        res = connection.__send__(method.to_sym, url, params)
      rescue Errno::ETIMEDOUT
        retry
      rescue Faraday::ParsingError
        sleep 5
        retry
      end
      process_response(res)
    end

    def build_url(args, fields_to_select = nil)
      url = oauth_api_domain ? "/#{entity_name}" : "/v1/#{entity_name}"
      url += "/#{args[1]}" if args[1]
      if fields_to_select.is_a?(::Array) && !fields_to_select.empty?
        url += ":(#{fields_to_select.join(',')})"
      end
      url += "?api_token=#{@api_token}" if @api_token
      url
    end

    def process_response(res)
      if res.success?
        data = if res.body.is_a?(::Hashie::Mash)
                 res.body.merge(success: true)
               else
                 ::Hashie::Mash.new(success: true)
               end
        return data
      end
      failed_response(res)
    end

    def failed_response(res)
      failed_res = res.body.merge(success: false, not_authorized: false,
                                  failed: false)
      case res.status
      when 401
        failed_res.merge! not_authorized: true
      when 420
        failed_res.merge! failed: true
      end
      failed_res
    end

    def entity_name
      class_name = self.class.name.split('::')[-1].downcase.pluralize
      class_names = {
        'people' => 'persons'
      }
      class_names[class_name] || class_name
    end

    def oauth_api_domain
      @oauth_credentials && @oauth_credentials[:api_domain]
    end

    def oauth_access_token
      @oauth_credentials && @oauth_credentials[:access_token]
    end

    def base_api_url
      oauth_api_domain || 'https://api.pipedrive.com'
    end

    def auth_headers
      oauth_access_token ? { Authorization: "Bearer #{oauth_access_token}" } : {}
    end

    def faraday_options
      {
        url: base_api_url,
        headers: {
          accept: 'application/json',
          user_agent: ::Pipedrive.user_agent,
          **auth_headers
        }
      }
    end

    # This method smells of :reek:TooManyStatements
    def connection # :nodoc
      @connection ||= Faraday.new(faraday_options) do |conn|
        conn.request :url_encoded
        conn.response :mashify
        conn.response :json, content_type: /\bjson$/
        conn.use FaradayMiddleware::ParseJson
        conn.response :logger, ::Pipedrive.logger if ::Pipedrive.debug
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
