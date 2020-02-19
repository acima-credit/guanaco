# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Base
        DEFAULT_RESPONSE_STATUS = 200

        JSON_CONTENT_TYPE  = 'application/json'
        PLAIN_CONTENT_TYPE = 'text/plain'

        class << self
          def handling(type, path = nil)
            Registry.add type, path, self
          end

          def handle(context)
            context.get_request.get_body.then { |body| new(context, body.get_text).handle }
          end

          def status(value = :no_value)
            @status = value unless value == :no_value
            return @status if instance_variable_defined?(:@status)

            parent = ancestors[1..-1].find { |x| x.respond_to?(:status) && !x.status.nil? }
            parent&.status || DEFAULT_RESPONSE_STATUS
          end

          def content_type(value = :no_value)
            @content_type = value unless value == :no_value
            return @content_type if instance_variable_defined?(:@content_type)

            parent = ancestors[1..-1].find { |x| x.respond_to?(:content_type) && !x.content_type.nil? }
            parent&.content_type
          end

          def blocking(value = :no_value)
            @blocking = value unless value == :no_value
            return @blocking if instance_variable_defined?(:@blocking)

            parent = ancestors[1..-1].find { |x| x.respond_to?(:blocking) && !x.blocking.nil? }
            parent&.blocking || false
          end
        end

        attr_reader :context, :request, :response_headers
        attr_accessor :response_status

        def initialize(context = nil, body = nil)
          @context          = ContextProxy.new context
          @request          = RequestProxy.new context, body
          @response_status  = self.class.status
          @response_headers = {}
          @finalized        = false
        end

        extend Forwardable
        def_delegators :@request, :body, :cookies, :path, :protocol, :query, :query_params, :raw_uri, :uri
        def_delegators :@request, :is_ajax_request, :headers, :params, :content_type

        def handle
          run_request
        rescue ::Exception => e
          render_exception e
        end

        def before_request; end

        def execute
          {}
        end

        def after_request(result)
          return if finalized?

          case result
          when String
            render body: result
            :string
          when Hash
            render_json result
            :hash
          else
            :skipped
          end
        end

        def render_exception(e)
          hsh = {
            status: 'error',
            message: 'There was an error processing your request',
            response_status: 500
          }
          return hsh unless Server.development?

          hsh[:message] += ": #{e.message}"
          hsh[:class]     = e.class
          hsh[:backtrace] = e.backtrace[0, 5]

          render_json hsh, status: 500
        end

        def render(options = {})
          response = get_response options[:status] || response_status
          update_headers response, options
          render_body response, options[:body] || ''
          @finalized = true
        end

        def render_json(value, options = {})
          render options.update(
            content_type: JSON_CONTENT_TYPE,
            body: JrJackson::Json.dump(value)
          )
        end

        def render_plain(value, options = {})
          render options.update(
            content_type: PLAIN_CONTENT_TYPE,
            body: value.to_s
          )
        end

        def redirect(*args)
          context.redirect(*args)

          @finalized = true
        end

        def finalized?
          @finalized
        end

        private

        def run_request
          before_request

          result = if self.class.blocking
                     RP_Blocking.get { execute }
                   else
                     execute
                   end

          if result.is_a?(RP_Promise)
            result.then { |value| after_request value }
          else
            after_request result
          end

          result
        end

        def get_response(code)
          ResponseProxy.new @context.get_response.status(code.to_i)
        end

        def update_headers(response, options)
          response_headers.merge options[:headers] || {}
          response_headers[:content_type] ||= options[:content_type] if options[:content_type]
          response_headers[:content_type] ||= self.class.content_type if self.class.content_type
          response.set_headers response_headers
        end

        def render_body(response, body)
          response.send_body body
        end
      end
    end
  end

  def self.base_handler
    Server::Handlers::Base
  end
end
