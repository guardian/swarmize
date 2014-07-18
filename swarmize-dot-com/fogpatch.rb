module Fog
  module AWS
    class ElasticBeanstalk < Fog::Service
      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        def initialize(options={})
          require 'fog/core/parser'

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)

          @connection_options = options[:connection_options] || {}
          options[:region] ||= 'us-east-1'
          @host = options[:host] || "elasticbeanstalk.#{options[:region]}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        # Returns an array of available solutions stack details
        def solution_stacks
          list_available_solution_stacks.body['ListAvailableSolutionStacksResult']['SolutionStackDetails']
        end

        private

        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token      = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @hmac                   = Fog::HMAC.new('sha256', @aws_secret_access_key)
        end

        def request(params)
          refresh_credentials_if_expired

          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :aws_session_token  => @aws_session_token,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2010-12-01'
            }
          )

          begin
            @connection.request({
              :body       => body,
              :expects    => 200,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :idempotent => idempotent,
              # :host       => @host,
              :method     => 'POST',
              :parser     => parser
            })
          rescue Excon::Errors::HTTPStatusError => error
            match = Fog::AWS::Errors.match_error(error)
            raise if match.empty?
            raise case match[:code]
          when 'InvalidParameterValue'
            Fog::AWS::ElasticBeanstalk::InvalidParameterError.slurp(error, match[:message])
          else
            Fog::AWS::ElasticBeanstalk::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
          end
        end
      end
    end
  end
end
end

